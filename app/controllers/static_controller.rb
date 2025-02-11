class StaticController < ApplicationController
  include ApplicationHelper

  layout 'public'

  def index
    @match_record = {
      player_1: {
        first_name: 'Roger',
        last_name: 'Halksworth',
        ntrp_rating: '3.5 C',
        wtn_singles_rating: '27.5'
      },
      player_2: {
        first_name: 'Brian',
        last_name: 'James',
        ntrp_rating: '3.0 C',
        wtn_singles_rating: '32.6'
      },
      header: 'Group 1 - Court 7 - Match 1',
      player_1_seed: '1',
      player_2_seed: '8',
      player_1_final_score: '10',
      player_2_final_score: '3',
      player_1_status: 'winner',
      player_2_status: 'loser'
    }
  end
end
