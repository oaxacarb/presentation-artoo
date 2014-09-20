require 'rubygems'
require 'bundler/setup'

require 'artoo'

connection :capture, :adaptor => :opencv_capture
device :capture, :driver => :opencv_capture, :connection => :capture, :interval => 3

connection :video, :adaptor => :opencv_window
device :video, :driver => :opencv_window, :connection => :video, :title => "Video", :interval => 3



work do
  haar = "#{Dir.pwd}/../artoo-opencv/examples/haarcascade_frontalface_alt.xml"

  on capture, :frame => proc { |*value|
    begin
      opencv = value[1]
      faces = opencv.detect_faces(haar)
      opencv.draw_rectangles!(faces)
      video.image = opencv.image
    rescue Exception => e
      puts e.message
    end
  }
end
