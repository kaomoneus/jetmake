set(BIGE_INIT_PREPROCESSOR ${CMAKE_SOURCE_DIR}/src/bige_initpp/initPreprocessor.py)

macro(addInitPreprocessor targetProj dest sources)
    message("Preprocessor has been added for ${targetProj}")
    set(initPPSources ${sources})
    add_custom_command(TARGET ${targetProj}
        PRE_BUILD
        COMMAND python ${BIGE_INIT_PREPROCESSOR} ${dest} ${CMAKE_CURRENT_SOURCE_DIR} ${initPPSources}
    )
endmacro(addInitPreprocessor)
