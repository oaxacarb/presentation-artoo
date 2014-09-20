require 'rubygems'
require 'bundler/setup'

require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '/dev/ttyACM0'
device :board, :driver => :device_info
device :led, :driver => :led, :pin => 13

connection :capture, :adaptor => :opencv_capture
device :capture, :driver => :opencv_capture, :connection => :capture, :interval => 1

connection :video, :adaptor => :opencv_window
device :video, :driver => :opencv_window, :connection => :video, :title => "Video", :interval => 1

work do
  haar = "#{Dir.pwd}/../artoo-opencv/examples/haarcascade_frontalface_alt.xml"
  on capture, :frame => proc { |*value|
    begin
      opencv = value[1]
      opencv.image = opencv.image.resize(::OpenCV::CvSize.new(opencv.image.width/4,opencv.image.height/4))
      faces = opencv.detect_faces(haar)
      opencv.draw_rectangles!(faces)
      faces.empty? ? led.off : led.on
      video.image = opencv.image
    rescue Exception => e
      puts e.message
    end
  }
end
