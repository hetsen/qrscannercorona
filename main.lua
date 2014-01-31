--[[


   ____    _____       _____    _____              _   _   _   _   ______   _____  
  / __ \  |  __ \     / ____|  / ____|     /\     | \ | | | \ | | |  ____| |  __ \ 
 | |  | | | |__) |   | (___   | |         /  \    |  \| | |  \| | | |__    | |__) |
 | |  | | |  _  /     \___ \  | |        / /\ \   | . ` | | . ` | |  __|   |  _  / 
 | |__| | | | \ \     ____) | | |____   / ____ \  | |\  | | |\  | | |____  | | \ \ 
  \___\_\ |_|  \_\   |_____/   \_____| /_/    \_\ |_| \_| |_| \_| |______| |_|  \_\
                                                                                   
                                                                                   
This is a QR Code scanner serverside. It is uploading your picture to 
your server, then it is linking it to zxing.org online decoder.
After decoding the json script gives you a json answer.


Just change the host to whatever your are using.


]]--

local host = "127.0.0.1"
local qrPic
local mime
local path
local fileHandle

local _W = display.contentWidth
local _H = display.contentHeight

local qrText = display.newText("",0,0,nil,24)
qrText.x, qrText.y = _W*.5, _H*.5

local json = require "json"

function uploadBinary ( filename, url, onComplete )
 
    mime = require "mime"
    path = system.pathForFile( filename, system.TemporaryDirectory )
    fileHandle = io.open( path, "rb" ) 
    print("Upload image")
    if fileHandle then 
        local params = { 
          headers = {
            ["Content-Type"] = "multipart/text"},
            body = mime.b64( fileHandle:read( "*a" ) ),
          }
        
        io.close( fileHandle )

        local function networkListener ( event )
            qrPic = event.response 
            print("Get filename")
            print("Image name"..qrPic)

          local function qrDecode( event )
              print("Comes to decoding")
              local response = json.decode(event.response)
              print(event.response)
              if event.response == "" then
                print("Not working try again.")
              else
                print(event.response)
              end
        end

            network.request( "http://"..host.."/parse.php?url=http://zxing.org/w/decode?u=http://"..host.."/"..qrPic, "GET", qrDecode ) -- Decode qr-code
        end
    
        network.request( url, "POST", networkListener,  params) -- Get filename
    end
end


local function onComplete(event)
   uploadBinary ( "image.jpg", "http://"..host.."/upload.php")
   print("Comes to onComplete")
end

if media.hasSource( media.Camera ) then
    media.capturePhoto( {listener = onComplete, destination = {baseDir=system.TemporaryDirectory, filename="image.jpg", type="image"} } )
else
   native.showAlert( "Fail!", "No camera found.", { "OK" } )
end

--"http://zxing.org/w/decode?u="
