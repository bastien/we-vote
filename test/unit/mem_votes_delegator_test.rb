require 'test_helper'
require 'benchmark'

class MemVotesDelegatorTest < ActiveSupport::TestCase
  fixtures :users, :delegations, :proposals, :votes
  
  def test_time_to_generate_delegated_votes
    Benchmark.bm do |x|
      x.report { MemVotesDelegator.start_delegation(1, 4) }
    end
    puts DelegatedVote.count
    puts DelegatedVote.last.last_value
    assert true
  end
  
end