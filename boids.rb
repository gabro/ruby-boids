require 'matrix'

MAX_X = 600
MAX_Y = 600
N_BOID = 20

class FlockSimulator
  def initialize
    @boids = initialize_positions
    
    rule1 = Proc.new do |bj|
      pcj = Vector[0,0]
      @boids.each do |b|
        if b != bj
          pcj += b.position
        end
      end
      pcj = pcj.map { |x| x / (@boids.size - 1) }
      delta = (pcj - bj.position).map { |x| x / 100}
      delta
    end

    rule2 = Proc.new do |bj|
      c = Vector[0,0]
      @boids.each do |b|
        if b != bj
          if b.distance(bj) < 50
            c -= (b.position - bj.position)
          end
        end
      end 
      c
    end

    rule3 = Proc.new do |bj|
      pvj = Vector[0,0]
      @boids.each do |b|
        if b != bj
          pvj += b.velocity
        end
      end
      pvj = pvj.map { |x| x / (@boids.size - 1) }
      (pvj - bj.velocity).map {|x| x / 8 }
    end

    @rules = [rule1, rule2, rule3]
  end

  def initialize_positions(n = N_BOID)
    Array.new(n) { Boid.new }
  end

  def simulate(iterations, renderer)
    iterations.times do
      move_to_new_position &renderer
    end
  end

  def move_to_new_position
    if block_given?
      yield @boids
    end
    deltas = Array.new(@boids.size) { Vector[0,0] }
    @boids.each_with_index do |boid, idx|
      @rules.each do |rule|
        deltas[idx] += rule.call boid
      end
    end

    @boids.each_with_index do |boid, idx|
      boid.position += deltas[idx]

      if boid.position.x < 0
        boid.position.x = 0
      elsif boid.position.x > MAX_X
        boid.position.x = MAX_X
      end

      if boid.position.y < 0
        boid.position.y = 0
      elsif boid.position.y > MAX_Y
        boid.position.y = MAX_Y
      end
    end
  end
end

class Boid
  attr_accessor :position, :velocity

  def initialize(x = rand(MAX_X), y = rand(MAX_Y))
    @position = Vector[x,y]
    @velocity = Vector[0,0]
  end

  def distance(boid)
    # Math.sqrt(self.position.to_a.zip(boid.position.to_a).map { |x| (x[1] - x[0])**2 }.reduce(:+))
    Math.sqrt((self.position.x - boid.position.x) ** 2 +
              (self.position.y - boid.position.y) ** 2)
  end

  def to_s
    "#{position.x}, #{position.y}"
  end
end

class Vector
  attr_accessor :x, :y
  def x
    self[0]
  end

  def y
    self[1]
  end

  def x=(new_x)
    self[0] = new_x
  end

  def y=(new_y)
    self[1] = new_y
  end
end

# s = FlockSimulator.new
# s.simulate(iterations = 10, renderer = nil)