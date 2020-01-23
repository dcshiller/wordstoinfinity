class MovesController < ApplicationController
  def create
    placements
    WordAdder.new(player).add(placements)
  end

  private

  def player
    Player.find_or_create_by_remote_address request["remote_address"]
  end

  def placements
    params[:placements].map { |p| Placement.new(p) }
  end
end
