class Button
  attr_reader :x
  attr_reader :y
  attr_reader :z
  attr_reader :width
  attr_reader :height

  include InputManager

  def initialize(width, height, viewport = nil, &block)
    @width = width
    @height = height
    @sprite = Sprite.new(viewport)
    @sprite.x = 0
    @sprite.y = 0
    if block_given?
      option = yield
      @sprite.x = @x = option[:x] if option.key? :x
      @sprite.y = @y = option[:y] if option.key? :y
      @button_bitmap = option[:bitmap] if option.key? :bitmap
      @sprite.bitmap = @button_bitmap[0]
    else
      @button_bitmap = Array.new(3)
    end

    @area = :out
    @mouse = :up
    @event_method = Hash.new
  end

  def x=(value)
    @sprite.x = @x = value
  end
  
  def y=(value)
    @sprite.y = @y = value
  end

  def z=(value)
    @sprite.z = @z = value
  end

  def set_image(index, bitmap)
    @button_bitmap[index] = bitmap
  end
  
  def set_method(type, mtd)
    @event_method[type] = mtd
  end
  
  def update
    update_bitmap
    update_input
  end

  def update_bitmap
    if !under_mouse?
      @sprite.bitmap = @button_bitmap[0]
    else
      if @mouse == :down
        if @button_bitmap[2].is_a?(Bitmap)
          @sprite.bitmap = @button_bitmap[2]
        else
          @sprite.bitmap = @button_bitmap[1]
        end
      else
        @sprite.bitmap = @button_bitmap[1]
      end
    end
  end

  def update_input
    if under_mouse?
      if InputManager.mouse_press?(Mouse::VK_LBUTTON)
        if @area == :in
          if @mouse == :up
            #p "down"
            @event_method[:button_down].call if @event_method[:button_down].is_a?(Method)
            @mouse = :down
          end
        end
      else
        @area = :in
        if @mouse == :down
          #p "up"
          @event_method[:button_up].call if @event_method[:button_up].is_a?(Method)
          @mouse = :up
        end
      end
    else
      @area = :out
      if InputManager.mouse_press?(Mouse::VK_LBUTTON)
        if @mouse == :down
          #p "!"
        end
      else
        @mouse = :up
      end
    end
  end

  def under_mouse?
    return InputManager.pos.x >= @x && InputManager.pos.x < @x + @width && InputManager.pos.y >= @y && InputManager.pos.y < @y + @height
  end
end