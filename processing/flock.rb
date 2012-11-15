# My Sketch

require "../boids"

class Flock < Processing::App

  def setup
    smooth
    frameRate 30
    @bird = loadShape("bird.svg")
    @cloud = loadShape("cloud.svg")
    @logo = loadShape("logo.svg")
    @font = createFont("MyriadPro", 32)
    textFont(@font)
    @simulator = FlockSimulator.new
  end

  def draw
    background(42, 82, 190)

    draw_clouds

    stroke(255, 255, 255)
    draw_title
    draw_authors

    @simulator.move_to_new_position do |boids|
      boids.each do |boid|
        draw_boid boid
      end
    end
  end

  def draw_title
    pushStyle
    textSize(12)
    textAlign(LEFT)
    text("Ruby Hack Night :: Flock Simulator", 5, 15)
    line(5, 20, width - 5, 20)
    popStyle
  end

  def draw_authors
    pushStyle
    textSize(12)
    fill(255, 255, 255)
    textAlign(RIGHT)
    text("G. Petronella & E. Colombo", width - 5, 15)
    popStyle
  end

  def draw_boid(boid)
    shape(@bird, boid.position.x, boid.position.y, @bird.width / 2, @bird.height / 2) 
  end

  def draw_logo
    lwidth = @logo.width
    lheight = @logo.height
    shape(@logo, width - lwidth, height - lheight, lwidth, lheight)
  end

  def draw_clouds
    shape(@cloud, 75, 300, @cloud.width * 10, @cloud.height * 10)
    shape(@cloud, 25, 370, @cloud.width * 8, @cloud.height * 8)
  end

end

Flock.new :title => "Flock", :width => 800, :height => 600
