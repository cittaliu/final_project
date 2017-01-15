class OpportunitiesController < ApplicationController

  def index
    @opportunities = Opportunity.all
  end

end
