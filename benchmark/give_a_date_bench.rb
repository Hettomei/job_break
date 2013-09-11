require 'benchmark'
require_relative '../models/give_a_date'

class GiveADateBench

  def bench_struct_or_initialize
    iterations = 10_000_000
    # this benchmark was created to determine if it s better to use
    # class < Struct.new :foo
    # or
    # def initialize
    # It need to be run 2 times
    Benchmark.bm do |bm|
      bm.report do
        iterations.times do
          GiveADate.new(:foo)
        end
      end
    end
    #result (after multiple times for all)
    # with def initialize (WINNER):
    # 0.530000   0.000000   0.530000 (  0.528289)
    # with < Struct.new :date
    # 0.570000   0.010000   0.580000 (  0.573948)
  end

  def bench_adamantium
    iterations = 1000_000
    # better to use ?
    # include Adamantium + memoize
    # or
    # nothing

    a = GiveADate.new('2012-1-1')
    Benchmark.bm do |bm|
      bm.report do
        iterations.times do
          a.to_date
        end
      end
    end
    # with nothing
    # user     system      total        real
    # 2.430000   0.000000   2.430000 (  2.437306)
    #
    # with adamantium
    # user     system      total        real
    # 5.870000   0.010000   5.880000 (  5.879553)
    # I will keep adamantium even if it loose
  end
end

a = GiveADateBench.new
#a.bench_struct_or_initialize
a.bench_adamantium
