prng = Random.new 4
print 'prng seed: '
p prng.seed

class PerfectNumber
  def self.classify n
    raise RuntimeError if n < 0
    %w[perfect deficient abundant].sample

  end
end

#   <<perfect
# ruby perfect_numbers_test.rb
# prng seed: 4
# Run options: --seed 58652
# 
# # Running:
# 
# ....
# 
# Finished in 0.000944s, 4236.5431 runs/s, 4236.5431 assertions/s.
# 
# 4 runs, 4 assertions, 0 failures, 0 errors, 0 skips
# perfect


# run with `rake SEED=58652`
