$dictionary = File.readlines('./app/services/usa.txt').map(&:chomp).to_set;

def valid?(word)
  $dictionary.include? word
end

class VerificationError < StandardError
end

class WordAdder
  attr_reader :errors, :prospective_placements


  def initialize(player)
    @player = player
    @errors = []
  end

  def add(prospective_placements)
    @prospective_placements = prospective_placements
    Placement.transaction do
      begin
        verify_touching # check letters exist before placing.
        save_move
        save_placements
        verify_continuity # check that letters now form continuous line
        verify_words # check that only valid words exist
      rescue VerificationError
        raise ActiveRecord::Rollback
      end
    end
    self
  end

  private

  def new_move
    @new_move ||= Move.new player: @player
  end

  def save_move
    new_move.save
  end

  def save_placements
    prospective_placements.each { |p| p.move = new_move }
    prospective_placements.each &:save
  end

  def verify_touching
    xs = prospective_placements.map { |p| p.x.to_i }
    ys = prospective_placements.map { |p| p.y.to_i }
    x_min = xs.min
    y_min = ys.min
    x_max = xs.max
    y_max = ys.max
    touching = Placement
      .between(x_min - 1, y_min - 1, x_max + 1, y_max + 1)
      .not_at(x_min - 1, y_min - 1)
      .not_at(x_min - 1, y_max + 1)
      .not_at(x_max + 1, y_min - 1)
      .not_at(x_max + 1, y_max + 1)

    errors << "Not touching" unless touching.exists?
  end

  def verify_continuity
    xs = prospective_placements.map { |p| p.x.to_i }
    ys = prospective_placements.map { |p| p.y.to_i }
    x_min = xs.min
    y_min = ys.min
    x_max = xs.max
    y_max = ys.max
    distance = x_max - x_min + y_max - y_min + 1
    count = Placement.between(x_min, y_min, x_max, y_max).count
    errors << "Gappy" unless distance == count
  end

  def verify_words
    x_coord, y_coord = prospective_placements.first.coords
    words = WordLocator.new(x_coord, y_coord).locate
    words.each { |w| errors << "#{w} is not valid" unless valid?(w) }
    raise VerificationError unless errors.empty?
  end
end
