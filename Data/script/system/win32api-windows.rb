class Win32API
  # API Functions
  FindWindow              = Win32API.new 'user32', 'FindWindow', 'pp', 'l' 
  GetActiveWindow         = Win32API.new 'user32', 'GetActiveWindow', 'v', 'l' 
  GetPrivateProfileString = Win32API.new 'kernel32', 'GetPrivateProfileString', 'pppplp', 'l' 
  FindWindow              = Win32API.new 'user32', 'FindWindow', 'pp', 'l' 
  GetWindowRect           = Win32API.new 'user32', 'GetWindowRect', 'lp', 'l' 
  GetSystemMetrics        = Win32API.new 'user32', 'GetSystemMetrics', 'l', 'l' 
  GetAsyncKeyState        = Win32API.new 'user32', 'GetAsyncKeyState', 'l', 'l' 
  AdjustWindowRect        = Win32API.new 'user32', 'AdjustWindowRect', 'pll', 'l' 
  GetClientRect           = Win32API.new 'user32', 'GetClientRect', 'lp','i' 
  ChangeDisplaySettings   = Win32API.new 'user32', 'ChangeDisplaySettingsW', 'pl', 'l' 
  SetWindowLong           = Win32API.new 'user32', 'SetWindowLongA', 'pll', 'l' 
  GetWindowLong           = Win32API.new 'user32', 'GetWindowLongA', 'll', 'l' 
  SetWindowPos            = Win32API.new 'user32', 'SetWindowPos', 'lllllll', 'l' 
  RegisterHotKey          = Win32API.new 'user32', 'RegisterHotKey', 'llll', 'l' 
  GetDesktopWindow        = Win32API.new 'user32', 'GetDesktopWindow', 'v', 'l' 
  GetForegroundWindow     = Win32API.new 'user32', 'GetForegroundWindow', 'v', 'l' 
  GetAncestor             = Win32API.new 'user32', 'GetAncestor', 'll', 'l' 
  GetClassName            = Win32API.new 'user32', 'GetClassName', 'lpl', 'l' 

  # Constants
  GWL_STYLE      = -16
  WS_BORDER      = 0x800000
  SWP_SHOWWINDOW = 0x40
  PELSHEIGHT     = 0x100000
  PEDTH          = 0x80000
  BITSPERPEL     = 0x00040000
  PELSWIDTH      = 0x00080000
  PELSHEIGHT     = 0x00100000
  CDS_FULLSCREEN = 0x00000004
  CDS_RESET = 0x40000000
  HWND_TOP = 0
  HWND_TOPMOST = -1
  MOD_ALT = 0x0001
  VK_RETURN = 0x0D
  KEY_LALT = 0xA4
  KEY_RETURN = 0x0D
  GA_ROOT = 2

  def self.get_hwnd
    buffer = "\0" * 256
    GetPrivateProfileString.call('Game', 'Title', '', buffer, buffer.size, 'Game.ini')
    hwnd = FindWindow.call('RGSS Player', buffer.delete!("\0"))
    hwnd = GetActiveWindow.call if hwnd == 0
    return hwnd
  end

  def self.get_rect_of_screen
    return Rect.new(0, 0, GetSystemMetrics.call(0), GetSystemMetrics.call(1))
  end

  def self.get_rect_of_taskbar
    buffer = "\0" * 16
    GetWindowRect.call(FindWindow.call('Shell_TrayWnd', 0), buffer)
    buffer = buffer.unpack('l4')
    return Rect.new(buffer[0], buffer[1], buffer[2] - buffer[0], buffer[3] - buffer[1])
  end

  def self.get_rect_of_adjust_window(width, height, style)
    buffer = [0, 0, width, height].pack('i4')
    AdjustWindowRect.call(buffer, style, 0)
    buffer = buffer.unpack('i4')
    return Rect.new(*buffer)
  end
end