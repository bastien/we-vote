require 'test_helper'
require 'benchmark'

class VoteDelegationTest < ActiveSupport::TestCase
  fixtures :delegations, :votes
  
  def test_time_to_generate_delegated_votes
    Benchmark.bm do |x|
      x.report { VotesDelegator.new(1).start }
    end
    assert true
  end
  
end