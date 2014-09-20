require 'artoo'

connection :arduino, adaptor: :firmata, port: '/dev/ttyACM0'
device :led, driver: :led, pin: 13
device :button, driver: :button, pin: 2, interval: 0.01

work do
  on button, :push    => proc { led.on }
  on button, :release => proc { led.off }
end
