module InputManager

  module Finger
    DOWN = 0x0
    UP   = 0x1
    DRAG = 0x2
  end

  Point = Struct.new(:x, :y)
  @@touch_pos = Point.new(nil, nil)
  @@touch_pos_down = Point.new(nil, nil)
  @@touch_pos_up = Point.new(nil, nil)

  @@state = Finger::UP
  @@dragged = false

  def self.update
    
  end

  def self.state
    return @@state
  end

  def self.pos
    return @@touch_pos
  end

  def self.down_pos
    return @@touch_pos_down
  end

  def self.up_pos
    return @@touch_pos_up
  end
  
  def self.callback_touch(finger_id, touch_x, touch_y, action)
    @@state = action
    if @@state == Finger::UP
      @@touch_pos.x, @@touch_pos.y = nil, nil
      @@touch_pos_down.x, @@touch_pos_down.y = nil, nil
      @@touch_pos_up.x, @@touch_pos_up.y = touch_x, touch_y
      @@dragged = false
    elsif @@state == Finger::DOWN
      @@touch_pos.x, @@touch_pos.y = touch_x, touch_y
      @@touch_pos_down.x, @@touch_pos_down.y = touch_x, touch_y
      @@touch_pos_up.x, @@touch_pos_up.y = nil, nil
      @@dragged = false
    elsif @@state == Finger::DRAG
      @@touch_pos.x, @@touch_pos.y = touch_x, touch_y
      @@dragged = true
    end
  end
end

module SDL
	class << self
		alias_method :handle_pad_touch, :handlePadTouch
		def handlePadTouch(*args)
			dw, dh = Graphics.entity.w.to_f, Graphics.entity.h.to_f
			gw, gh = Graphics.width.to_f, Graphics.height.to_f
			r = dh / gh
			gw2 = gw * r
			ew2 = (dw - gw2) / 2
			r2 = dw / gw2
			InputManager.callback_touch(args[0], (args[1] - ew2 / dw) * gw * r2, args[2] * gh, args[3])
			handle_pad_touch(*args)
		end
	end
end