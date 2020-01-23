class StateController < ApplicationController
  def index
    @placements = Placement.all
  end
end
