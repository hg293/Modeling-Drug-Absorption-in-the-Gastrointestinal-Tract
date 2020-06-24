
function biocontrol_project_hg_2019(block)
  % Level-2 M file S-Function for limited integrator demo.
  % Copyright 1990-2009 The MathWorks, Inc.
  % $Revision: 1.1.6.1 $ 
  
  setup(block);
  
  % endfunction

function setup(block)
  
  %% Register number of dialog parameters   
  block.NumDialogPrms = 3;

  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 2;      
  
  %% Setup functional port properties to dynamically inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
  % Set number of signals going through input port
  block.InputPort(1).Dimensions        = 1 %;
  block.InputPort(1).DirectFeedthrough = false;
  
  % Set number of signals going through each output port
  block.OutputPort(1).Dimensions       = 5;       
  block.OutputPort(2).Dimensions       = 5;                                              % one output channel
  
  % Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Continuous States
  block.NumContStates = 10;
  
  % ------------------------------------------------------------------------
  % From: http://www.mathworks.com/help/toolbox/simulink/sfg/f7-67622.html#f7-68771
 
  % If your S-function needs continuous states, initialize the number 
  % of continuous states in the setup method using the run-time object's 
  % NumContStates property. Do not initialize discrete states in the setup method.
  %  
  % Initialize the discrete states in the PostPropagationSetup method. 
  % A Level-2 MATLAB S-function stores discrete state information in a DWork vector. 
  % The default PostPropagationSetup method in the template file suffices for this example.
 
  % ------------------------------------------------------------------------
    
    
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
  block.RegBlockMethod('InitializeConditions',     @InitConditions);  
  block.RegBlockMethod('Outputs',                  @Output);  
  block.RegBlockMethod('Derivatives',              @Derivative);  
  block.RegBlockMethod('SetInputPortSamplingMode', @SetInputPortFrameData);


function SetInputPortFrameData(block, idx, fd)

  block.InputPort(1).SamplingMode = fd;
  block.OutputPort(1).SamplingMode = fd;
  block.OutputPort(2).SamplingMode = fd;
  
  % end SetInputPortFrameData


function InitConditions(block)

global Do Dn

  Do = [11.4, 2.54, 0.08, 133, 3.08];  % Dose number of Piroxicam, Chlorthiazide, Digoxin, Griseofulvin, and Carbamazepine, respectively
  Dn = [0.15, 17.0, 0.52, 0.32, 5.61]; % Dissolution number of Piroxicam, Chlorthiazide, Digoxin, Griseofulvin, and Carbamazepine, respectively

  block.ContStates.Data(1)  = block.DialogPrm(2).Data;      
  block.ContStates.Data(2)  = block.DialogPrm(1).Data;      
  
  block.ContStates.Data(3)  = block.DialogPrm(2).Data;      
  block.ContStates.Data(4)  = block.DialogPrm(1).Data;      
  
  block.ContStates.Data(5)  = block.DialogPrm(2).Data;     
  block.ContStates.Data(6)  = block.DialogPrm(1).Data;      
  
  block.ContStates.Data(7)  = block.DialogPrm(2).Data;     
  block.ContStates.Data(8)  = block.DialogPrm(1).Data;      
  
  block.ContStates.Data(9)  = block.DialogPrm(2).Data;      
  block.ContStates.Data(10) = block.DialogPrm(1).Data;      
 
  % endfunction

function Output(block)
  
  block.OutputPort(1).Data(1) = block.ContStates.Data(1);
  block.OutputPort(1).Data(2) = block.ContStates.Data(3);
  block.OutputPort(1).Data(3) = block.ContStates.Data(5);
  block.OutputPort(1).Data(4) = block.ContStates.Data(7);
  block.OutputPort(1).Data(5) = block.ContStates.Data(9);
  
  block.OutputPort(2).Data(1) = block.ContStates.Data(2);
  block.OutputPort(2).Data(2) = block.ContStates.Data(4);
  block.OutputPort(2).Data(3) = block.ContStates.Data(6);
  block.OutputPort(2).Data(4) = block.ContStates.Data(8);
  block.OutputPort(2).Data(5) = block.ContStates.Data(10);

  % endfunction

function Derivative(block)
global Dn Do r1 C1 r2 C2 r3 C3 r4 C4 r5 C5 An

  An = block.DialogPrm(3).Data;  % 3rd parameter

  r1  = block.ContStates.Data(1); 
  C1  = block.ContStates.Data(2);
  block.Derivatives.Data(1)  = -(Dn(1)/3)*((1-C1)/r1);         % Piroxicam radius
  block.Derivatives.Data(2)  = -Dn(1)*Do(1)*r1*(1-C1) - 2*An*C1; % Piroxicam concentration
    
  r2  = block.ContStates.Data(3);
  C2  = block.ContStates.Data(4); 
  block.Derivatives.Data(3)  = -(Dn(2)/3)*((1-C2)/r2);         % Chlorthiazide radius
  block.Derivatives.Data(4)  = -Dn(2)*Do(2)*r2*(1-C2) - 2*An*C2; % Chlorthiazide concentration
   
  r3  = block.ContStates.Data(5);
  C3  = block.ContStates.Data(6);
  block.Derivatives.Data(5)  = -(Dn(3)/3)*((1-C3)/r3);         % Digoxin radius
  block.Derivatives.Data(6)  = -Dn(3)*Do(3)*r3*(1-C3) - 2*An*C3; % Digoxin concentration
   
  r4  = block.ContStates.Data(7);
  C4  = block.ContStates.Data(8);
  block.Derivatives.Data(7)  = -(Dn(4)/3)*((1-C4)/r4);         % Griseofulvin radius
  block.Derivatives.Data(8)  = -Dn(4)*Do(4)*r4*(1-C4) - 2*An*C4; % Griseofulvin concentration

  r5  = block.ContStates.Data(9);
  C5  = block.ContStates.Data(10);
  block.Derivatives.Data(9)  = -(Dn(5)/3)*((1-C5)/r5);         % Carbamazepine radius
  block.Derivatives.Data(10) = -Dn(5)*Do(5)*r5*(1-C5) - 2*An*C5; % Carbamazepine concentration
     
  % endfunction

