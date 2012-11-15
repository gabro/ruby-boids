require 'matrix'

MAX_X = 400
MAX_Y = 400
N_BOID = 2

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
			pcj = pcj.map { |x| x / @boids.size - 1 }
			(pcj - bj.position).map { |x| x / 100}
		end

		rule2 = Proc.new do |bj|
			c = Vector[0,0]
			@boids.each do |b|
				if b != bj
					d = (b.position - bj.position).map { |e| e.abs }
					if d.to_a.select {|x| x < 10}.size > 0
						c -= b.position - bj.position
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
			pvj = pvj.map { |x| x / @boids.size - 1 }
			(pvj - bj.velocity).map {|x| x / 8 }
		end

		@rules = [rule1, rule2, rule3]
	end

	def initialize_positions(n = N_BOID)
		Array.new(n) { Boid.new }
	end

	def simulate(renderer, n)
		n.times do
			renderer.call @boids
			move_to_new_position
		end
	end

	def move_to_new_position
		@boids.each do |boid|
			@rules.each do |rule|
				boid.velocity += rule.call boid
			end
			boid.position += boid.velocity

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

	def initialize
		@position = Vector[Random.rand(MAX_X), Random.rand(MAX_Y)]
		@velocity = Vector[0,0]
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


simulator = FlockSimulator.new

renderer = Proc.new do |boids|
	puts boids
	puts
end

simulator.simulate(renderer, 10)