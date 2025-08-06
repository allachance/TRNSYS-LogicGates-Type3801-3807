Subroutine Type3802
   !------------------------------------------------------------------------------------
   !    DESCRIPTION
   !------------------------------------------------------------------------------------
   ! Subroutine Type3802 implements a logical NAND gate in a TRNSYS simulation. It
   ! evaluates inputs and computes their NAND result based on the selected mode.
   !
   ! Parameters:
   !   Mode: Defines how inputs are interpreted:
   !     Mode 1: Inputs must be strictly 0 or 1; other values trigger an error.
   !     Mode 2: Inputs are true if greater than 0.
   !     Mode 3: Inputs are true if nonzero.
   !
   ! Inputs:
   !   Dynamic Number of Inputs: Multiple inputs are evaluated using the
   !   selected mode.
   !
   ! Outputs:
   !   Returns 0 if all inputs are true; otherwise returns 1.
   !
   ! Version History:
   !   2025-05-01 – A. Lachance: Original implementation.
   !
   ! Export this subroutine for use in external DLLs.
   !DEC$ATTRIBUTES DLLEXPORT :: TYPE3802
   !------------------------------------------------------------------------------------
   !    VARIABLES
   !------------------------------------------------------------------------------------
   Use TrnsysConstants
   Use TrnsysFunctions
   Implicit None

   Double Precision :: timestep, time
   Integer :: currentUnit, currentType

   Integer :: logic_mode, input_count, input_index
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
      input_count = getNumberOfInputs()

      If ((logic_mode < 1) .or. (logic_mode > 3)) Then
         Call FoundBadParameter(1, 'Fatal', ' must be between value of 1 and 3.')
      End If

      If (ErrorFound()) Return

      ! TRNSYS Engine Type Calls
      Call SetNumberofParameters(1)
      Call SetNumberofInputs(input_count)
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
      input_count = getNumberOfInputs()
   End If

   !------------------------------------------------------------------------------------
   !    MAIN TYPE CODE
   !------------------------------------------------------------------------------------
   logic_mode = getParameterValue(1)
   input_count = getNumberOfInputs()

   output_flag = .TRUE.

   Do input_index = 1, input_count
      input_value = GetInputValue(input_index)

      Select Case (logic_mode)
      Case (1) ! Logic mode 1: input must be 0 or 1
         If (input_value /= 0.d0 .and. input_value /= 1.d0) Then
            Call FoundBadInput(input_index, 'Fatal', ' must be a value of 0 or 1.')
            Cycle ! Cycle to evaluate all inputs for errors
         End If
         input_flag = (input_value == 1.d0)

      Case (2) ! Logic mode 2: input must be greater than 0
         input_flag = (input_value > 0.d0)

      Case (3) ! Logic mode 3: input must not be 0

         input_flag = (input_value /= 0.d0)
      End Select

      If (input_flag .EQV. .FALSE.) Then
         output_flag = .FALSE. ! Do not exit to evaluate all inputs for errors
      End If
   End Do

   If (ErrorFound()) Return

   Call setOutputValue(1, MERGE(0.d0, 1.d0, output_flag))! 0 if True

   Return
End
