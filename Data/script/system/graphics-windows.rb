module Graphics
  def self.resize_screen(width, height)
    hwnd = Win32API.get_hwnd
    win_style = Win32API::GetWindowLong.call(hwnd, Win32API::GWL_STYLE)
    screen_rect = Win32API.get_rect_of_screen
    window_rect = Win32API.get_rect_of_adjust_window(width, height, win_style)
    taskbar_rect = Win32API.get_rect_of_taskbar
    Win32API::SetWindowLong.call(hwnd, Win32API::GWL_STYLE, win_style)
    x = screen_rect.width - window_rect.width + window_rect.x
    x -= taskbar_rect.width if screen_rect.width != taskbar_rect.width
    y = screen_rect.height - window_rect.height + window_rect.y
    y -= taskbar_rect.height if screen_rect.height != taskbar_rect.height
    Win32API::SetWindowPos.call(hwnd, Win32API::HWND_TOP, x / 2, y / 2, window_rect.width - window_rect.x, window_rect.height - window_rect.y, Win32API::SWP_SHOWWINDOW)
  end
end
=begin
      
      # 외부 Alt + Enter 키 금지
      RegisterHotKey.call(HWND, 0, MOD_ALT, VK_RETURN)
      
      # DEVMODE 구조체
      def self.getDEVMODE(width, height)
        devmode =
        [
          0,0,0,0,0,0,0,0,                # Q8
          0,                              # L
          220,                            # S
          0,                              # S
          BITSPERPEL|PELSWIDTH|PELSHEIGHT,# L
          0,0,                            # Q2
          0,0,0,0,0,                      # S5
          0,0,0,0,0,0,0,0,                # Q8
          # dmLogPixels
          0,                              # S
          # dmBitsPerPel
          32,                             # L
          # dmPelsWidth
          width,                          # L
          # dmPelsHeight
          height,                         # L
          # dmDitherType
          0,                              # Q
          0,0,0,0                         # Q4
        ].pack('Q8 L S2 L Q2 S5 Q8 S L3 Q5') 
        return devmode
      end
    
      # 윈도우 크기 취득
      def rect
        pos = ([0]*4).pack('l4')
        GetClientRect.call(HWND, pos)
        return pos.unpack('l4')
      end
      
      # 너비
      def width; @width=rect[2] end
      
      # 높이
      def height; @height=rect[3] end
      
      # 풀스크린 여부
      def is_fullscreen?
        activeWnd = GetForegroundWindow.call
        return false if activeWnd == 0
        activeWnd = GetAncestor.call(activeWnd, GA_ROOT)
        return false if activeWnd == 0
        buf = ' ' * 256
        return false if GetClassName.call(HWND, buf, buf.size) == 0
        buf[/\000.*/] = ''
        classname = buf
        return false if (desktopWnd = GetDesktopWindow.call) == 0
        desktop = ([0]*4).pack('l4')
        return false if GetWindowRect.call(desktopWnd, desktop) == 0
        desktop = desktop.unpack('l4')
        client = ([0]*4).pack('l4')
        return false if GetClientRect.call(activeWnd, client) == 0
        client = client.unpack('l4')
        clientSize = [ client[2] - client[0], client[3] - client[1] ]
        desktopSize = [ desktop[2] - desktop[0], desktop[3] - desktop[1] ]
        return false if (clientSize[0] < desktopSize[0] || clientSize[1] < desktopSize[1])
        return activeWnd == HWND
      end
    
      # 해상도 변경
      def resize_screen(width, height, fullscreen=false)

      end
      
      # 인게임 Alt + Enter 키 누를 시 처리
      def self.alt_enter?
        if GetAsyncKeyState.call(KEY_LALT) & 0x8000 > 0
          if GetAsyncKeyState.call(KEY_RETURN) & 0x8000 > 0
            Graphics.resize_screen(Graphics.width, Graphics.height, !Graphics.is_fullscreen?)
          end
        end
      end
    end
    
    module Input
      class << self
        alias :resolution_update :update unless $@
        def update(*args)
          resolution_update(*args)
          Graphics.alt_enter? if $WINDOW_ALTENTER
        end
      end
    end
=end