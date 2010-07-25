require 'test_helper'
require 'benchmark'
module WeVote
  class VotesDelegatorTest < ActiveSupport::TestCase
    fixtures :delegations, :votes
  
    def test_time_to_generate_delegated_votes
      Benchmark.bm do |x|
        x.report { WeVote::VotesDelegator.start_delegation(1, 4) }
      end
      puts WeVote::DelegatedVote.count
      puts WeVote::DelegatedVote.last.last_value
      assert true
    end
  
  end
end