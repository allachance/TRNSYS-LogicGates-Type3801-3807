Subroutine Type3807
   !------------------------------------------------------------------------------------
   !    DESCRIPTION
   !------------------------------------------------------------------------------------
   ! Subroutine Type3807 implements a logical NOT gate in a TRNSYS simulation. It
   ! evaluates inputs and computes their NOT result based on the selected mode.
   !
   ! Parameters:
   !   Mode: Defines how inputs are interpreted:
   !     Mode 1: Inputs must be strictly 0 or 1; other values trigger an error.
   !     Mode 2: Inputs are true if greater than 0.
   !     Mode 3: Inputs are true if nonzero.
   !
   ! Input:
   !   Input to be evaluated
   !
   ! Outputs:
   !  Returns 0 if True, return 1 if False
   !
   ! Version History:
   !   2025-05-01 – A. Lachance: Original implementation.
   !
   ! Export this subroutine for use in external DLLs.
   !DEC$ATTRIBUTES DLLEXPORT :: TYPE3807
   !------------------------------------------------------------------------------------
   !    VARIABLES
   !------------------------------------------------------------------------------------
   Use TrnsysConstants
   Use TrnsysFunctions
   Implicit None

   Double Precision :: timestep, time
   Integer :: currentUnit, currentType

   Integer :: logic_mode
   Double Precision :: input_value
   logical :: input_flag, output_flag

   !------------------------------------------------------------------------------------
   !    INITIALIZATION
   !------------------------------------------------------------------------------------
   ! Get global TRNSYS simulation variables
   time = getSimulationTime()
   timestep = getSimulationTimeStep()
   currentUnit = getCurrentUnit()
   currentType = getCurrentType()

   !------------------------------------------------------------------------------------
   !    VERSION CHECK
   !------------------------------------------------------------------------------------
   If (getIsVersionSigningTime()) Then
      Call SetTypeVersion(17)
      Return
   End If

   !------------------------------------- ----------------------------------------------
   !    FINAL CALL HANDLING
   !------------------------------------------------------------------------------------
   If (getIsLastCallofSimulation() .or. getIsEndOfTimestep()) Then
      Return
   End If

   !------------------------------------------------------------------------------------
   !    TYPE INITIALIZATION
   !------------------------------------------------------------------------------------
   If (getIsFirstCallofSimulation()) Then
      logic_mode = getParameterValue(1)

      If ((logic_mode < 1) .or. (logic_mode > 3)) Then
         Call FoundBadParameter(1, 'Fatal', ' must be between value of 1 and 3.')
      End If

      If (ErrorFound()) Return

      ! TRNSYS Engine Type Calls
      Call SetNumberofParameters(1)
      Call SetNumberofInputs(1)
      Call SetNumberofDerivatives(0)
      Call SetNumberofOutputs(1)
      Call SetIterationMode(1)
      Call SetNumberStoredVariables(0, 0)
      Call SetNumberofDiscreteControls(0)

      ! TRNSYS Input and Output Units
      ! Nothing

      Return
   End If

   !------------------------------------------------------------------------------------
   !    INITIAL VALUE SETTING
   !------------------------------------------------------------------------------------
   If (getIsStartTime()) Then
      Call setOutputValue(1, 0)
      Return
   End If

   !------------------------------------------------------------------------------------
   !    RE-READ PARAMETERS
   !------------------------------------------------------------------------------------
   If (getIsReReadParameters()) Then
      logic_mode = getParameterValue(1)
   End If

   !------------------------------------------------------------------------------------
   !    MAIN TYPE CODE
   !------------------------------------------------------------------------------------
   logic_mode = getParameterValue(1)
   input_value = GetInputValue(1)

   Select Case (logic_mode)
   Case (1) ! Logic mode 1: input must be 0 or 1
      If (input_value /= 0.d0 .and. input_value /= 1.d0) Then
         Call FoundBadInput(1, 'Fatal', ' must be a value of 0 or 1.')
      End If
      input_flag = (input_value == 1.d0)

   Case (2) ! Logic mode 2: input must be greater than 0
      input_flag = (input_value > 0.d0)

   Case (3) ! Logic mode 3: input must not be 0

      input_flag = (input_value /= 0.d0)
   End Select

   If (ErrorFound()) Return

   output_flag = .NOT. input_flag

   Call setOutputValue(1, MERGE(1.d0, 0.d0, output_flag)) ! 1 if True

   Return
End
