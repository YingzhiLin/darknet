#rm test_dnn_out.avi

./darknet detector demo ./d/obj.data ./d/yolo-obj.cfg ./d/weights/yolo-obj_final.weights rtsp://admin:admin12345@192.168.0.228:554 -i 0 -thresh 0.25



