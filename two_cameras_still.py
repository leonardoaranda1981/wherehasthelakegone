from picamera2 import Picamera2, Preview
from libcamera import Transform, controls
from picamera2.encoders import H264Encoder
from gpiozero import Button
import time
from time import sleep
from datetime import datetime, timezone
from zoneinfo import ZoneInfo

import os
import serial

btnGrabar = Button(24)
btnDetener  = Button(23)
estado_grabacion = False
latlong = ""
folderName = ""
    
#camara izquierda
cam0 = Picamera2 (camera_num=0)
#camara derecha
cam1 = Picamera2 (camera_num=1)

ctrls1 = {'FrameRate':30.0, 'SyncMode': controls.rpi.SyncModeEnum.Server}
ctrls2 = {'FrameRate':30.0, 'SyncMode': controls.rpi.SyncModeEnum.Client}

still_config1 = cam0.create_still_configuration({"size":(1920,1080), "format": "RGB888"},controls=ctrls1,transform=Transform(vflip=True), raw={"size":cam0.sensor_resolution})
still_config2 = cam1.create_still_configuration({"size":(1920,1080), "format": "RGB888"},controls=ctrls2,transform=Transform(vflip=True), raw={"size":cam1.sensor_resolution})

cam0.configure (still_config1)
cam1.configure (still_config2)

"""
encoder1 = H264Encoder (bitrate=5000000)
encoder1.sync_enable = True
encoder2 = H264Encoder (bitrate=5000000)
encoder2.sync_enable = True
"""
ser = serial.Serial(
        port='/dev/ttyACM0',  # or '/dev/ttyAMA0'
        baudrate=115200,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS,
        timeout=1  # Timeout in seconds
    )



def captureStill():
    #     datetime.now().isoformat(timespec='milliseconds') for ISO 8601 compliant output.
    timestamp = datetime.now(ZoneInfo("America/Mexico_City"))
    date_string = timestamp.strftime("%Y-%m-%d")#_%H%M%S
    #     time_string = timestamp.strftime("%H%M%S")
    time_string = timestamp.isoformat(timespec='milliseconds')
    #new_directory = os.path.join(date_string ,time_string)
    os.makedirs(date_string+folderName, exist_ok = True)
    #os.makedirs(new_directory, exist_ok = True)
    output1 = date_string+folderName+"/"+time_string+","+latlong+"_izq.png"
    output2 = date_string+folderName+"/"+time_string+","+latlong+"_der.png"
    cam0.start()
    cam1.start()
    cam0.capture_file(output1)
    cam1.capture_file(output2)
    print("Recording has started")
    cam0.stop()
    cam1.stop()
    
try:
    while True:
        if btnGrabar.is_pressed:
            if not estado_grabacion:
                captureStill()
                
        if ser.in_waiting > 0:
            line = ser.readline().decode('utf-8').strip() # Decode bytes to string and remove whitespace
            print(f"Received: {line}")
            if '&' in line:
                if line == "&capture-still":
                    captureStill()
            elif '@' in line:
                latlong = line.split(":")[1];
            elif '#' in line:
                folderName = line.split(".")[0][1:];
                print("New folder name:"+folderName);
                
            time.sleep(0.1)
            
except KeyboardInterrupt:
    print("Exiting serial reader.")
    
finally:
    ser.close() # Close the serial port when done
        
            

