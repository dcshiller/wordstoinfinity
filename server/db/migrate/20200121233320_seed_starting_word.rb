class SeedStartingWord < ActiveRecord::Migration[6.0]
  def change
    player = Player.create remote_address: 'system'
    move = Move.create player: player
    x_position = 0
    "wordstoinfinity".split("").each do |letter|
      Placement.create value: letter, y: 0, x: x_position, move: move
      x_position += 1
    end
  end
end
