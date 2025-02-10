'********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub Main()
  showChannelSGScreen()
end sub

sub showChannelSGScreen()
  print "in showChannelSGScreen"
  'Indicate this is a Roku SceneGraph application'
  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)

  'Create a scene and load /components/helloworld.xml' 
  scene = screen.CreateScene("AmbientMode")
  screen.show()
  ' vscode_rdb_on_device_component_entry
  m.deviceInfo = CreateObject("roDeviceInfo")
  m.dport = CreateObject("roMessagePort")
  m.deviceInfo.SetMessagePort(m.dport)
  m.deviceInfo.EnableScreensaverExitedEvent(true)
  m.deviceInfo.EnableInternetStatusEvent(true)


  while(true)
      msg = wait(0, m.port)
      msgType = type(msg)
      if msgType = "roSGScreenEvent"
          if msg.isScreenClosed() then return
      end if
  end while

  ' Monitor user inactivity
  m.input = createObject("roInput")
  m.input.setMessagePort(m.port)
  m.input.enableInput(true)

  ' Start inactivity timer
  m.top.idleTimeout = 0
  m.inactivityTimer = createObject("roTimespan")
  m.inactivityTimer.mark()

  while true
    msg = wait(1000, m.port)
    ' dmsg = wait(1000,m.dport)
    if m.inactivityTimer.totalSeconds() >= 7100
      m.inactivityTimer.mark()
      ' m.deviceInfo.ResetScreensaverTimeout()
    end if
    if msg <> invalid
      if type(msg) = "roInputEvent"
        m.inactivityTimer.mark()
      end if
    end if
  end while
end sub