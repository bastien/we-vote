require 'test_helper'
require 'benchmark'

class VotesDelegatorTest < ActiveSupport::TestCase
  fixtures :delegations, :votes
  
  def test_time_to_generate_delegated_votes
    Benchmark.bm do |x|
      x.report { VotesDelegator.start_delegation(1, 4) }
    end
    puts DelegatedVote.count
    puts DelegatedVote.last.last_value
    assert true
  end
  
end