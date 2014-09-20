require 'artoo'

# Substitute the button with an analog sensor like a photoresistor and
# change to the correct analog input, in this case pin A0.
# Circuit and schematic here: http://arduino.cc/en/tutorial/button

connection :firmata, :adaptor => :firmata, :port => '/dev/ttyACM0'

device :sensor, driver: :analog_sensor, pin: 0, interval: 0.25, upper: 900, lower: 200
device :led, :driver => :led, :pin => 13

work do
  puts
  puts "Leyendo el sensor del pin #{ sensor.pin }"
  puts "Leyendo a intervalos de => #{ sensor.interval }"
  puts "Valor inicial del sensor => #{ sensor.analog_read(0) }"
  puts "Valor superior con valor => #{ sensor.upper }"
  puts "Valor inferior con valor => #{ sensor.lower }"

  on sensor, :upper => proc {
    puts "¡Límite Superior alcanzado!"
    led.off
  }

  on sensor, :lower => proc {
    puts "¡Límite Inferior alcanzado!"
    led.on
  }
end
