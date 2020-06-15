# fpga_neural_network
Mnist Handwritten Character (0-9) Recognition 
 
Mnist Character Recognition is done using hardware FPGA board Basys3. Hardware implementation is preferred over software implementation as hardware is faster than software. This is especially of concern in performing tasks where performance matters.   
      
    ● Image feeding 
       ○ The 28*28 pixel​ ​values of the image have to be either comma-separated, space-separated or a combination of both. 
       ○ Replace the first 784 values of the ​.coe​ file with these pixels without changing the format of the weight values already present (beginning as 2, 0, 2, 5, -1….)  
    ● Training 
       ○ After extracting the weight values from the python code, we ran into an obstacle. It was not worthwhile to implement floating-point numbers in Verilog, so we scaled up the weights by 100 in order to compensate for the rounding of done in Verilog. 
    ● Verilog code 
       ○ Block RAM generator: 
            ■ Using the IP catalogue to include the Block RAM module in our code. 
            ■ Once created, set the write and read width as 9 bits and write and read depth as 8724 bits (exact values justified while explaining the code). 
            ■ Load coe file from path: B_RAM\final_weights.coe 
            ■ Initialising the registers to set B RAM in read mode as ​wire read and ​wire ena​ and take in address and values at that address as reg aA​ and ​wire outA​. 
       ○ Setting the biases: 
            ■ Initialising the registers to store the summation of the weighted inputs of layer 1 and layer 2 as ​reg s​ and ​reg f​. 
            ■ Initialising these registers with biases to normalise the values of the summations. 
       ○ Clock divider:
            ■ This part was added to the code because the implementation of the code on the FPGA demanded a slower clock due to the complexity of the logic gates involved in the code. 
       ○ Always block: 
            ■ First, the image pixels are read from the first 784 pixels stored in the B RAM by applying a ​Threshold​ function.  
            ■ Then the first layer weights are accessed from the B RAM and the summation of the weighted inputs for each node in the second layer are calculated. 
            ■ We have dealt with negative numbers in a different manner as we haven’t used signed registers.  
            ■ Then the ​Relu​ function is applied to the values of the ten nodes obtained. 
            ■ Next, the second layer weights are accessed from the B RAM and the summation of the weighted inputs for each node in the output layer are calculated. 
       ○ Determination of number recognised: 
            ■ Now the maximum of the values in the output layer is found out and that index is classified as the determined number. 
            ■ Then the corresponding seven segment code for the number is found out.  
    ● Constraint file  
       ○ Choose the constraint file from the given path:  B_RAM\7_seg.xdc 
       ○ The .xdc file maps the divided clock into the ​U16 ​LED, the determined number into ​N3​, ​P3​, ​U3​ and ​W3​ LEDs (​A[3:0]​) and also on the seven segment display.  
    ● Simulation settings 
       ○ Set simulation run time to 4 million nanoseconds; to compensate for the time complexity of the code. 
 
                              The code is currently set up with the value of ‘3’ 
 
    Team Members: Aditya Pusalkar, Arpita Kabra, Aishna Agrawal, Janvi Thakkar, Udit Vyas. 
