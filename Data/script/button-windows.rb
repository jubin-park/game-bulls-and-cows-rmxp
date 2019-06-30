class Button
  attr_reader :x
  attr_reader :y
  attr_reader :z
  attr_reader :width
  attr_reader :height
  attr_reader :state_area
  attr_reader :state_mouse

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
      @index = option[:index] if option.key? :index
      @sprite.bitmap = @button_bitmap[0] if !@button_bitmap.nil?
    else
      @button_bitmap = Array.new(3)
      @index = nil
    end
    @state_area = :out
    @state_mouse = :up
    @event_method = Hash.new
  end
  
  def dispose
    @button_bitmap.each do |bitmap|
      bitmap.dispose
      bitmap = nil
    end
    @sprite.dispose
    @sprite = nil
  end

  def sprite
    @sprite
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

  def update
    update_input
  end

  def opacity
    @sprite.opacity
  end

  def opacity=(value)
    @sprite.opacity = value
  end

  def set_image(index, bitmap)
    @button_bitmap[index] = bitmap
  end
  
  def set_method(type, mtd)
    @event_method[type] = mtd
  end
  
  def update_bitmap
    return if @sprite.opacity <= 0
    return if @sprite.visible == false
    if !under_mouse?
      @sprite.bitmap = @button_bitmap[0]
    else
      if @state_mouse == :down
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
        if @state_area == :in
          if @state_mouse == :up
            #p "down"
            if @event_method[:button_down].is_a?(Method)
              if @index.nil?
                @event_method[:button_down].call
              else
                @event_method[:button_down].call(@index)
              end
            end
            @state_mouse = :down
          end
        end
      else
        @state_area = :in
        if @state_mouse == :down
          #p "up"
          if @event_method[:button_up].is_a?(Method)
            if @index.nil?
              @event_method[:button_up].call
            else
              @event_method[:button_up].call(@index)
            end
          end
          @state_mouse = :up
        end
      end
    else
      @state_area = :out
      if InputManager.mouse_press?(Mouse::VK_LBUTTON)
        if @state_mouse == :down
          #p "!"
        end
      else
        @state_mouse = :up
      end
    end
  end

  def under_mouse?
    return false if @sprite.opacity <= 0
    return false if @sprite.visible == false
    return InputManager.pos.x >= @x && InputManager.pos.x < @x + @width && InputManager.pos.y >= @y && InputManager.pos.y < @y + @height
  end
end