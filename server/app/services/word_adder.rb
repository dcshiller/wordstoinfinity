$dictionary = File.readlines('./app/services/usa.txt').map(&:chomp).to_set;

def valid?(word)
  $dictionary.include? word
end

class WordAdder
   def initialize(player)
     @player = player
   end

   def add(prospective_placements)
     new_move = Move.new player: @player
     Placement.transaction do
        new_move.save
        prospective_placements.each { |p| p.move = new_move }
        prospective_placements.each &:save
        x_coord, y_coord = prospective_placements.first.coords
        words = WordLocator.new(x_coord, y_coord).locate
        raise ActiveRecord::Rollback unless words.all? { |w| valid?(w) }
     end
     return false unless new_move.persisted?
     return new_move
   end
end
