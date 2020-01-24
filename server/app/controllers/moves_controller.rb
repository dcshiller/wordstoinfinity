class MovesController < ApplicationController
  def create
    placements
    @errors = WordAdder.new(player).add(placements).errors
  end

  private

  def player
    Player.find_or_create_by remote_address: request["remote_address"]
  end

  def placements
    @placements ||= placement_params.map { |p| Placement.new(p) }
  end

  def placement_params
    params.permit(placements: [:x, :y, :value])["placements"]
  end
end
