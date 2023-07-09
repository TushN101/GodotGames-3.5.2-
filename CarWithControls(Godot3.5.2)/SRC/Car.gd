#ALERT
#wORKS ONLY ON 3.5.2 VERSION
extends VehicleBody

var max_rpm = 500
var max_torque = 200 #Torque is the engine force which is like the accel	aration in the car

func _process(delta):
	#Press v to get a pov view
	if Input.is_action_pressed("pov"):
		$Camroot/h/v/CameraFree.set_current(true)
	#Press b to get a outside view
	if Input.is_action_pressed("outside"):
		$Camroot/h/v/Camera.set_current(true)

#Some of the comments here are generated via chatgpt to make explaination more compact and easier to understand

func _physics_process(delta):
	 # This line calculates the interpolated value of steering using lerp.
	 #It gradually transitions the steering value from its current value towards 
	 #the scaled input value (Input.get_axis("right", "left") * 0.4). The rate of transition
	 #is controlled by the product of 5 * delta.
	steering = lerp(steering , Input.get_axis("right", "left") * 0.4 , 5 * delta)
	#This function retrieves the input value from two axes, "right" and "left". 
	#It assumes that these axes are set up in the project's
	#input settings to capture user input, such as pressing 
	#the arrow keys or gamepad joystick in the respective directions.
	var accelaration = Input.get_axis("back" , "forward") 
	#The acceleration variable will hold a floating-point value between -1.0 and 1.0,
	#representing the intensity or magnitude of the input from the "back" and "forward" axes
	var rpm = $back_left_wheel.get_rpm()
	#Getting the rpm of the back left wheel ands storing it in the rpm varialbe
	
	$back_left_wheel.engine_force = accelaration * max_torque * (1 - rpm/max_rpm)
	#Acceleartion is the value 1 or -1 dependsing opon the input
	#max torque is the real accelaration that will be multiplied 
	#The expression (1 - rpm/max_rpm) calculates a ratio that represents the
	#relative difference between the current RPM (rpm) and the maximum RPM (max_rpm).
	#The above code is necessary for realastic peformance
	rpm = $black_right_wheel.get_rpm()
	
	$black_right_wheel.engine_force = accelaration * max_torque * (1 - rpm/max_rpm)

#Torque = Force x Length 
#Torque deals with the accelaration of the car
#RPM deals with the speed of the car
