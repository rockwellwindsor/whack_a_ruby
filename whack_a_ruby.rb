require 'gosu'

class WhackARuby < Gosu::Window

  def initialize
    # Set the window size
    super(3000,1800)
    # Caption the window
    self.caption = "Whack the Ruby!"
    # Create the images
    @ruby   = Gosu::Image.new('assets/img/karthikeyan-ruby-flatmix-300px.png')
    # Ruby image variables
    @ruby_x = 200
    @ruby_y = 200
    @ruby_w = 50
    @ruby_h = 43
    @ruby_v_x = 10
    @ruby_v_y = 10
    # Draw the hammer
    @hammer = Gosu::Image.new('assets/img/david-benjamin-Hammer-300px.png')

    # Determines if the ruby is visible or not
    @visible = 0
    # Registers a hit on the ruby
    @hit = 0
    # Handles drawing the score and time, as well as game controls to the window
    @font = Gosu::Font.new(30)
    @score = 0
    # Tracks the status of the game
    @playing = true
    # Tracking time of the game
    @start_time = 0
  end

  def draw
    if @visible > 0
      @ruby.draw(@ruby_x - @ruby_w / 2, @ruby_y - @ruby_h / 2, 1)
    end
    # Draw the hammer where the mouse is
    @hammer.draw(mouse_x - 40, mouse_y - 10, 1)
    # Flash a color based on a connected hit, or a miss
    if @hit == 0
      c = Gosu::Color::NONE
    elsif @hit == 1
      c = Gosu::Color::GREEN
    elsif @hit == -1
      c = Gosu::Color::RED
    end
    # Color the background
    draw_quad(0, 0, c, 3000, 0, c, 3000, 1800, c, 0, 1800, c)
    @hit = 0
    # update the score
    @font.draw(@score.to_s, 2600, 20, 10)
    # update the amount of time left
    @font.draw(@time_left.to_s, 2800, 20, 10)
    # Check if game is over or not
    unless @playing
      @font.draw('Game Over', 1500, 1000, 10)
      @font.draw('Press the space bar to play again', 750, 1500, 10)
      @visible = 20
    end
  end

  def update
    if @playing
      # Moves the ruby around the screen
      @ruby_x += @ruby_v_x
      @ruby_y += @ruby_v_y
      # Keep the ruby in the bounds of the screen
      @ruby_v_x *= -1 if @ruby_x + @ruby_w / 2 > 2750 || @ruby_x - @ruby_w / 2 < 0
      @ruby_v_y *= -1 if @ruby_y + @ruby_h / 2 > 1600 || @ruby_y - @ruby_h / 2 < 0
      # Track visibility of the ruby
      @visible -= 1
      @visible = 250 if @visible < -10 && rand < 0.01
      # Track how much time is left
      @time_left = (100 - ((Gosu.milliseconds - @start_time) / 1000))
      # End game when time runs out
      @playing = false if @time_left < 0
    end
  end

  def button_down(id)
    if @playing
      if (id == Gosu::MsLeft)
        # Determine if the swing was a hit or a miss
        if Gosu.distance(mouse_x, mouse_y, @ruby_x, @ruby_y) < 100 && @visible >= 0
          @hit = 1
          @score += 5
        else
          @hit = -1
          @score -= 1
        end
      end
    else
      # Game is over, track a restart
      if (id == Gosu::KbSpace)
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end
end

# Create a new instance of the window
window = WhackARuby.new
# Show the window
window.show
