module InputManager

  module Mouse
    VK_LBUTTON = 0x1
    VK_RBUTTON = 0x2
    VK_MBUTTON = 0x4
    WHEEL_DELTA = 120
  end

  Point = Struct.new(:x, :y)
  @@mouse_pos = Point.new(nil, nil)
  @@delta = 0

  HWND = Win32API.get_hwnd
  
  def self.update
    @@mouse_pos.x, @@mouse_pos.y = get_mouse_pos(get_mouse_pos_in_screen)
  end

  def self.pos
    return @@mouse_pos
  end

  def self.wheel_delta
    return @@delta
  end

  def self.wheel_clear
    @@delta = 0
  end

  def self.mouse_trigger?(key)
    return Win32API::GetAsyncKeyState.call(key) & 0x1 == 0x1
  end

  def self.mouse_press?(key)
    return Win32API::GetAsyncKeyState.call(key) & 0x8000 == 0x8000
  end

  def self.mouse_wheel(delta, keys, x, y)
    @@delta = delta / Mouse::WHEEL_DELTA
  end
  if !defined? Wheel
    Wheel = Win32API.new('rm-mouse-wheel', 'intercept', 'v', 'v')
    Wheel.call
  end

  def self.get_mouse_pos(pos)
    return nil if pos == nil
    pos = pos.pack('ii')
    return pos.unpack('ii') if Win32API::ScreenToClient.call(HWND, pos) != 0
    return nil
  end

  def self.get_mouse_pos_in_screen
    pos = [0, 0].pack('ii')
    return pos.unpack('ii') if Win32API::GetCursorPos.call(pos) != 0
    return nil
  end
end
