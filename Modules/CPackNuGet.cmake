# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
CPackNuGet
----------

When build a NuGet package there is no direct way to control an output
filename due a lack of the corresponding CLI option of NuGet, so there
is no ``CPACK_NUGET_PACKAGE_FILENAME`` variable. To form the output filename
NuGet uses the package name and the version according to its built-in rules.

Also, be aware that including a top level directory
(``CPACK_INCLUDE_TOPLEVEL_DIRECTORY``) is ignored by this generator.


Variables specific to CPack NuGet generator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CPackNuGet may be used to create NuGet packages using :module:`CPack`.
CPackNuGet is a :module:`CPack` generator thus it uses the ``CPACK_XXX``
variables used by :module:`CPack`.

CPackNuGet has specific features which are controlled by the specifics
:code:`CPACK_NUGET_XXX` variables. In the "one per group" mode
(see :variable:`CPACK_COMPONENTS_GROUPING`), ``<compName>`` placeholder
in the variables below would contain a group name (uppercased and turned into
a "C" identifier).

List of CPackNuGet specific variables:

.. variable:: CPACK_NUGET_COMPONENT_INSTALL

 Enable component packaging for CPackNuGet

 * Mandatory : NO
 * Default   : OFF

.. variable:: CPACK_NUGET_PACKAGE_NAME
              CPACK_NUGET_<compName>_PACKAGE_NAME

 The NUGET package name.

 * Mandatory : YES
 * Default   : :variable:`CPACK_PACKAGE_NAME`

.. variable:: CPACK_NUGET_PACKAGE_VERSION
              CPACK_NUGET_<compName>_PACKAGE_VERSION

 The NuGet package version.

 * Mandatory : YES
 * Default   : :variable:`CPACK_PACKAGE_VERSION`

.. variable:: CPACK_NUGET_PACKAGE_DESCRIPTION
              CPACK_NUGET_<compName>_PACKAGE_DESCRIPTION

 A long description of the package for UI display.

 * Mandatory : YES
 * Default   :
    - :variable:`CPACK_COMPONENT_<compName>_DESCRIPTION`,
    - ``CPACK_COMPONENT_GROUP_<groupName>_DESCRIPTION``,
    - :variable:`CPACK_PACKAGE_DESCRIPTION`

 .. variable:: CPACK_NUGET_PACKAGE_AUTHORS
               CPACK_NUGET_<compName>_PACKAGE_AUTHORS

 A comma-separated list of packages authors, matching the profile names
 on nuget.org_. These are displayed in the NuGet Gallery on
 nuget.org_ and are used to cross-reference packages by the same
 authors.

 * Mandatory : YES
 * Default   : :variable:`CPACK_PACKAGE_VENDOR`

.. variable:: CPACK_NUGET_PACKAGE_TITLE
              CPACK_NUGET_<compName>_PACKAGE_TITLE

 A human-friendly title of the package, typically used in UI displays
 as on nuget.org_ and the Package Manager in Visual Studio. If not
 specified, the package ID is used.

 * Mandatory : NO
 * Default   :
    - :variable:`CPACK_COMPONENT_<compName>_DISPLAY_NAME`,
    - ``CPACK_COMPONENT_GROUP_<groupName>_DISPLAY_NAME``

.. variable:: CPACK_NUGET_PACKAGE_OWNERS
              CPACK_NUGET_<compName>_PACKAGE_OWNERS

 A comma-separated list of the package creators using profile names
 on nuget.org_. This is often the same list as in authors,
 and is ignored when uploading the package to nuget.org_.

 * Mandatory : NO
 * Default   : -

.. variable:: CPACK_NUGET_PACKAGE_HOMEPAGE_URL
              CPACK_NUGET_<compName>_PACKAGE_HOMEPAGE_URL

 A URL for the package's home page, often shown in UI displays as well
 as nuget.org_.

 * Mandatory : NO
 * Default   : :variable:`CPACK_PACKAGE_HOMEPAGE_URL`

.. variable:: CPACK_NUGET_PACKAGE_LICENSEURL
              CPACK_NUGET_<compName>_PACKAGE_LICENSEURL

 A URL for the package's license, often shown in UI displays as well
 as nuget.org_.

 * Mandatory : NO
 * Default   : -

.. variable:: CPACK_NUGET_PACKAGE_ICONURL
              CPACK_NUGET_<compName>_PACKAGE_ICONURL

 A URL for a 64x64 image with transparency background to use as the
 icon for the package in UI display.

 * Mandatory : NO
 * Default   : -

.. variable:: CPACK_NUGET_PACKAGE_DESCRIPTION_SUMMARY
              CPACK_NUGET_<compName>_PACKAGE_DESCRIPTION_SUMMARY

 A short description of the package for UI display. If omitted, a
 truncated version of description is used.

 * Mandatory : NO
 * Default   : :variable:`CPACK_PACKAGE_DESCRIPTION_SUMMARY`

.. variable:: CPACK_NUGET_PACKAGE_RELEASE_NOTES
              CPACK_NUGET_<compName>_PACKAGE_RELEASE_NOTES

 A description of the changes made in this release of the package,
 often used in UI like the Updates tab of the Visual Studio Package
 Manager in place of the package description.

 * Mandatory : NO
 * Default   : -

.. variable:: CPACK_NUGET_PACKAGE_COPYRIGHT
              CPACK_NUGET_<compName>_PACKAGE_COPYRIGHT

 Copyright details for the package.

 * Mandatory : NO
 * Default   : -

.. variable:: CPACK_NUGET_PACKAGE_TAGS
              CPACK_NUGET_<compName>_PACKAGE_TAGS

 A space-delimited list of tags and keywords that describe the
 package and aid discoverability of packages through search and
 filtering.

 * Mandatory : NO
 * Default   : -

.. variable:: CPACK_NUGET_PACKAGE_DEPENDENCIES
              CPACK_NUGET_<compName>_PACKAGE_DEPENDENCIES

 A list of package dependencies.

 * Mandatory : NO
 * Default   : -

.. variable:: CPACK_NUGET_PACKAGE_DEPENDENCIES_<dependency>_VERSION
              CPACK_NUGET_<compName>_PACKAGE_DEPENDENCIES_<dependency>_VERSION

 A `version specification`_ for the particular dependency, where
 ``<dependency>`` is an item of the dependency list (see above)
 transformed with ``MAKE_C_IDENTIFIER`` function of :command:`string`
 command.

 * Mandatory : NO
 * Default   : -

.. variable:: CPACK_NUGET_PACKAGE_DEBUG

 Enable debug messages while executing ``CPackNuGet.cmake``.

 * Mandatory : NO
 * Default   : OFF


.. _nuget.org: http://nuget.org
.. _version specification: https://docs.microsoft.com/en-us/nuget/reference/package-versioning#version-ranges-and-wildcards

.. NuGet spec docs https://docs.microsoft.com/en-us/nuget/reference/nuspec

#]=======================================================================]

# Author: Alex Turbov

if(CMAKE_BINARY_DIR)
  message(FATAL_ERROR "CPackNuGet.cmake may only be used by CPack internally.")
endif()

function(_cpack_nuget_debug)
    if(CPACK_NUGET_PACKAGE_DEBUG)
        message("CPackNuGet:Debug: " ${ARGN})
    endif()
endfunction()

function(_cpack_nuget_debug_var NAME)
    if(CPACK_NUGET_PACKAGE_DEBUG)
        message("CPackNuGet:Debug: ${NAME}=`${${NAME}}`")
    endif()
endfunction()

function(_cpack_nuget_variable_fallback OUTPUT_VAR_NAME NUGET_VAR_NAME)
    if(ARGN)
        list(JOIN ARGN "`, `" _va_args)
        set(_va_args ", ARGN: `${_va_args}`")
    endif()
    _cpack_nuget_debug(
        "_cpack_nuget_variable_fallback: "
        "OUTPUT_VAR_NAME=`${OUTPUT_VAR_NAME}`, "
        "NUGET_VAR_NAME=`${NUGET_VAR_NAME}`"
        "${_va_args}"
      )

    set(_options USE_CDATA)
    set(_one_value_args LIST_GLUE)
    set(_multi_value_args FALLBACK_VARS)
    cmake_parse_arguments(PARSE_ARGV 0 _args "${_options}" "${_one_value_args}" "${_multi_value_args}")

    if(CPACK_NUGET_PACKAGE_COMPONENT)
        string(
            TOUPPER "${CPACK_NUGET_PACKAGE_COMPONENT}"
            CPACK_NUGET_PACKAGE_COMPONENT_UPPER
          )
    endif()

    if(CPACK_NUGET_PACKAGE_COMPONENT
      AND CPACK_NUGET_${CPACK_NUGET_PACKAGE_COMPONENT}_PACKAGE_${NUGET_VAR_NAME}
      )
        set(
            _result
            "${CPACK_NUGET_${CPACK_NUGET_PACKAGE_COMPONENT}_PACKAGE_${NUGET_VAR_NAME}}"
          )
        _cpack_nuget_debug(
            "  CPACK_NUGET_${CPACK_NUGET_PACKAGE_COMPONENT}_PACKAGE_${NUGET_VAR_NAME}: "
            "OUTPUT_VAR_NAME->${OUTPUT_VAR_NAME}=`${_result}`"
          )

    elseif(CPACK_NUGET_PACKAGE_COMPONENT_UPPER
      AND CPACK_NUGET_${CPACK_NUGET_PACKAGE_COMPONENT_UPPER}_PACKAGE_${NUGET_VAR_NAME}
      )
        set(
            _result
            "${CPACK_NUGET_${CPACK_NUGET_PACKAGE_COMPONENT_UPPER}_PACKAGE_${NUGET_VAR_NAME}}"
          )
        _cpack_nuget_debug(
            "  CPACK_NUGET_${CPACK_NUGET_PACKAGE_COMPONENT_UPPER}_PACKAGE_${NUGET_VAR_NAME}: "
            "OUTPUT_VAR_NAME->${OUTPUT_VAR_NAME}=`${_result}`"
          )

    elseif(CPACK_NUGET_PACKAGE_${NUGET_VAR_NAME})
        set(_result "${CPACK_NUGET_PACKAGE_${NUGET_VAR_NAME}}")
        _cpack_nuget_debug(
            "  CPACK_NUGET_PACKAGE_${NUGET_VAR_NAME}: "
            "OUTPUT_VAR_NAME->${OUTPUT_VAR_NAME}=`${_result}`"
          )

    else()
        foreach(_var IN LISTS _args_FALLBACK_VARS)
            _cpack_nuget_debug("  Fallback: ${_var} ...")
            if(${_var})
                _cpack_nuget_debug("            ${_var}=`${${_var}}`")
                set(_result "${${_var}}")
                _cpack_nuget_debug(
                    "  ${_var}: OUTPUT_VAR_NAME->${OUTPUT_VAR_NAME}=`${_result}`"
                  )
                break()
            endif()
        endforeach()
    endif()

    if(_result)
        if(_args_USE_CDATA)
            set(_value_before "<![CDATA[")
            set(_value_after "]]>")
        endif()

        list(LENGTH _result _result_len)
        if(_result_len GREATER 1 AND _args_LIST_GLUE)
            list(JOIN _result "${_args_LIST_GLUE}" _result)
        endif()

        set(${OUTPUT_VAR_NAME} "${_value_before}${_result}${_value_after}" PARENT_SCOPE)
    endif()

endfunction()

function(_cpack_nuget_variable_fallback_and_wrap_into_element ELEMENT NUGET_VAR_NAME)
    set(_options)
    set(_one_value_args)
    set(_multi_value_args FALLBACK_VARS)
    cmake_parse_arguments(PARSE_ARGV 0 _args "${_options}" "${_one_value_args}" "${_multi_value_args}")

    _cpack_nuget_variable_fallback(_value ${NUGET_VAR_NAME} ${ARGN} USE_CDATA)

    if(_value)
        string(TOUPPER "${ELEMENT}" _ELEMENT_UP)
        set(
            _CPACK_NUGET_${_ELEMENT_UP}_TAG
            "<${ELEMENT}>${_value}</${ELEMENT}>"
            PARENT_SCOPE
          )
    endif()
endfunction()

# Print some debug info
_cpack_nuget_debug("---[CPack NuGet Input Variables]---")
_cpack_nuget_debug_var(CPACK_PACKAGE_NAME)
_cpack_nuget_debug_var(CPACK_PACKAGE_VERSION)
_cpack_nuget_debug_var(CPACK_TOPLEVEL_TAG)
_cpack_nuget_debug_var(CPACK_TOPLEVEL_DIRECTORY)
_cpack_nuget_debug_var(CPACK_TEMPORARY_DIRECTORY)
_cpack_nuget_debug_var(CPACK_NUGET_GROUPS)
if(CPACK_NUGET_GROUPS)
    foreach(_group IN LISTS CPACK_NUGET_GROUPS)
        string(MAKE_C_IDENTIFIER "${_group}" _group_up)
        string(TOUPPER "${_group_up}" _group_up)
        _cpack_nuget_debug_var(CPACK_NUGET_${_group_up}_GROUP_COMPONENTS)
    endforeach()
endif()
_cpack_nuget_debug_var(CPACK_NUGET_COMPONENTS)
_cpack_nuget_debug_var(CPACK_NUGET_ALL_IN_ONE)
_cpack_nuget_debug_var(CPACK_NUGET_ORDINAL_MONOLITIC)
_cpack_nuget_debug("-----------------------------------")

function(_cpack_nuget_render_spec)
    # Make a variable w/ upper-cased component name
    if(CPACK_NUGET_PACKAGE_COMPONENT)
        string(TOUPPER "${CPACK_NUGET_PACKAGE_COMPONENT}" CPACK_NUGET_PACKAGE_COMPONENT_UPPER)
    endif()

    # Set mandatory variables (not wrapped into XML elements)
    # https://docs.microsoft.com/en-us/nuget/reference/nuspec#required-metadata-elements
    if(CPACK_NUGET_PACKAGE_COMPONENT)
        if(CPACK_NUGET_${CPACK_NUGET_PACKAGE_COMPONENT_UPPER}_PACKAGE_NAME)
            set(
                CPACK_NUGET_PACKAGE_NAME
                "${CPACK_NUGET_${CPACK_NUGET_PACKAGE_COMPONENT_UPPER}_PACKAGE_NAME}"
              )
        elseif(NOT CPACK_NUGET_PACKAGE_COMPONENT STREQUAL "Unspecified")
            set(
                CPACK_NUGET_PACKAGE_NAME
                "${CPACK_PACKAGE_NAME}.${CPACK_NUGET_PACKAGE_COMPONENT}"
              )
        else()
            set(CPACK_NUGET_PACKAGE_NAME "${CPACK_PACKAGE_NAME}")
        endif()
    elseif(NOT CPACK_NUGET_PACKAGE_NAME)
        set(CPACK_NUGET_PACKAGE_NAME "${CPACK_PACKAGE_NAME}")
    endif()

    _cpack_nuget_variable_fallback(
        CPACK_NUGET_PACKAGE_VERSION VERSION
        FALLBACK_VARS
            CPACK_PACKAGE_VERSION
      )
    _cpack_nuget_variable_fallback(
        CPACK_NUGET_PACKAGE_DESCRIPTION DESCRIPTION
        FALLBACK_VARS
            CPACK_COMPONENT_${CPACK_NUGET_PACKAGE_COMPONENT}_DESCRIPTION
            CPACK_COMPONENT_${CPACK_NUGET_PACKAGE_COMPONENT_UPPER}_DESCRIPTION
            CPACK_COMPONENT_GROUP_${CPACK_NUGET_PACKAGE_COMPONENT_UPPER}_DESCRIPTION
            CPACK_PACKAGE_DESCRIPTION
        USE_CDATA
      )
    _cpack_nuget_variable_fallback(
        CPACK_NUGET_PACKAGE_AUTHORS AUTHORS
        FALLBACK_VARS
            CPACK_PACKAGE_VENDOR
        USE_CDATA
        LIST_GLUE ","
      )

    # Set optional variables (wrapped into XML elements)
    # https://docs.microsoft.com/en-us/nuget/reference/nuspec#optional-metadata-elements
    _cpack_nuget_variable_fallback_and_wrap_into_element(
        title
        TITLE
        FALLBACK_VARS
            CPACK_COMPONENT_${CPACK_NUGET_PACKAGE_COMPONENT}_DISPLAY_NAME
            CPACK_COMPONENT_${CPACK_NUGET_PACKAGE_COMPONENT_UPPER}_DISPLAY_NAME
            CPACK_COMPONENT_GROUP_${CPACK_NUGET_PACKAGE_COMPONENT_UPPER}_DISPLAY_NAME
      )
    _cpack_nuget_variable_fallback_and_wrap_into_element(owners OWNERS LIST_GLUE ",")
    _cpack_nuget_variable_fallback_and_wrap_into_element(
        projectUrl
        HOMEPAGE_URL
        FALLBACK_VARS
            CPACK_PACKAGE_HOMEPAGE_URL
      )
    _cpack_nuget_variable_fallback_and_wrap_into_element(licenseUrl LICENSEURL)
    _cpack_nuget_variable_fallback_and_wrap_into_element(iconUrl ICONURL)
    _cpack_nuget_variable_fallback_and_wrap_into_element(
        summary DESCRIPTION_SUMMARY
        FALLBACK_VARS
            CPACK_PACKAGE_DESCRIPTION_SUMMARY
      )
    if(CPACK_NUGET_PACKAGE_REQUIRE_LICENSE_ACCEPTANCE)
        set(
            _CPACK_NUGET_REQUIRELICENSEACCEPTANCE_TAG
            "<requireLicenseAcceptance>true</requireLicenseAcceptance>"
          )
    endif()
    _cpack_nuget_variable_fallback_and_wrap_into_element(releaseNotes RELEASE_NOTES)
    _cpack_nuget_variable_fallback_and_wrap_into_element(copyright COPYRIGHT)
    _cpack_nuget_variable_fallback_and_wrap_into_element(tags TAGS LIST_GLUE " ")

    # Handle dependencies
    _cpack_nuget_variable_fallback(_deps DEPENDENCIES)
    set(_collected_deps)
    foreach(_dep IN LISTS _deps)
        _cpack_nuget_debug("  checking dependency `${_dep}`")

        string(MAKE_C_IDENTIFIER "${_dep}" _dep_id)

        _cpack_nuget_variable_fallback(_ver DEPENDENCIES_${_dep_id}_VERSION)

        if(NOT _ver)
            string(TOUPPER "${_dep_id}" _dep_id)
            _cpack_nuget_variable_fallback(_ver DEPENDENCIES_${_dep_id}_VERSION)
        endif()

        if(_ver)
            _cpack_nuget_debug("  got `${_dep}` dependency version ${_ver}")
            list(APPEND _collected_deps "<dependency id=\"${_dep}\" version=\"${_ver}\" />")
        endif()
    endforeach()

    # Render deps into the variable
    if(_collected_deps)
        set(_CPACK_NUGET_DEPENDENCIES_TAG "<dependencies>\n")
        foreach(_line IN LISTS _collected_deps)
            string(
                APPEND _CPACK_NUGET_DEPENDENCIES_TAG
                "            ${_line}\n"
              )
        endforeach()
        string(APPEND _CPACK_NUGET_DEPENDENCIES_TAG "        </dependencies>")
    endif()

    # Render the spec file
    # NOTE The spec filename doesn't matter. Being included into a package,
    # NuGet will name it properly.
    _cpack_nuget_debug("Rendering `${CPACK_TEMPORARY_DIRECTORY}/CPack.NuGet.nuspec` file...")
    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/CPack.NuGet.nuspec.in"
        "${CPACK_TEMPORARY_DIRECTORY}/CPack.NuGet.nuspec"
        @ONLY
      )
endfunction()

function(_cpack_nuget_make_files_tag)
    set(_files)
    foreach(_comp IN LISTS ARGN)
        string(APPEND _files "        <file src=\"${_comp}\\**\" target=\".\" />\n")
    endforeach()
    set(_CPACK_NUGET_FILES_TAG "<files>\n${_files}    </files>" PARENT_SCOPE)
endfunction()

find_program(NUGET_EXECUTABLE NuGet)
_cpack_nuget_debug_var(NUGET_EXECUTABLE)
if(NOT NUGET_EXECUTABLE)
    message(FATAL_ERROR "NuGet executable not found")
endif()

# Add details for debug run
if(CPACK_NUGET_PACKAGE_DEBUG)
    list(APPEND CPACK_NUGET_PACK_ADDITIONAL_OPTIONS "-Verbosity" "detailed")
endif()

# Case one: ordinal all-in-one package
if(CPACK_NUGET_ORDINAL_MONOLITIC)
    # This variable `CPACK_NUGET_ALL_IN_ONE` set by C++ code:
    # Meaning to pack all installed files into a single package
    _cpack_nuget_debug("---[Making an ordinal monolitic package]---")
    _cpack_nuget_render_spec()
    execute_process(
        COMMAND "${NUGET_EXECUTABLE}" pack ${CPACK_NUGET_PACK_ADDITIONAL_OPTIONS}
        WORKING_DIRECTORY "${CPACK_TEMPORARY_DIRECTORY}"
      )

elseif(CPACK_NUGET_ALL_IN_ONE)
    # This variable `CPACK_NUGET_ALL_IN_ONE` set by C++ code:
    # Meaning to pack all installed components into a single package
    _cpack_nuget_debug("---[Making a monolitic package from installed components]---")

    # Prepare the `files` element which include files from several components
    _cpack_nuget_make_files_tag(${CPACK_NUGET_COMPONENTS})
    _cpack_nuget_render_spec()
    execute_process(
        COMMAND "${NUGET_EXECUTABLE}" pack ${CPACK_NUGET_PACK_ADDITIONAL_OPTIONS}
        WORKING_DIRECTORY "${CPACK_TEMPORARY_DIRECTORY}"
      )

else()
    # Is there any grouped component?
    if(CPACK_NUGET_GROUPS)
        _cpack_nuget_debug("---[Making grouped component(s) package(s)]---")
        foreach(_group IN LISTS CPACK_NUGET_GROUPS)
            _cpack_nuget_debug("Starting to make the package for group `${_group}`")
            string(MAKE_C_IDENTIFIER "${_group}" _group_up)
            string(TOUPPER "${_group_up}" _group_up)

            # Render a spec file which includes all components in the current group
            unset(_CPACK_NUGET_FILES_TAG)
            _cpack_nuget_make_files_tag(${CPACK_NUGET_${_group_up}_GROUP_COMPONENTS})
            # Temporary set `CPACK_NUGET_PACKAGE_COMPONENT` to the group name
            # to properly collect various per group settings
            set(CPACK_NUGET_PACKAGE_COMPONENT ${_group})
            _cpack_nuget_render_spec()
            unset(CPACK_NUGET_PACKAGE_COMPONENT)
            execute_process(
                COMMAND "${NUGET_EXECUTABLE}" pack ${CPACK_NUGET_PACK_ADDITIONAL_OPTIONS}
                WORKING_DIRECTORY "${CPACK_TEMPORARY_DIRECTORY}"
              )
        endforeach()
    endif()
    # Is there any single component package needed?
    if(CPACK_NUGET_COMPONENTS)
        _cpack_nuget_debug("---[Making single-component(s) package(s)]---")
        foreach(_comp IN LISTS CPACK_NUGET_COMPONENTS)
            _cpack_nuget_debug("Starting to make the package for component `${_comp}`")
            # Render a spec file which includes only given component
            unset(_CPACK_NUGET_FILES_TAG)
            _cpack_nuget_make_files_tag(${_comp})
            # Temporary set `CPACK_NUGET_PACKAGE_COMPONENT` to the current
            # component name to properly collect various per group settings
            set(CPACK_NUGET_PACKAGE_COMPONENT ${_comp})
            _cpack_nuget_render_spec()
            unset(CPACK_NUGET_PACKAGE_COMPONENT)
            execute_process(
                COMMAND "${NUGET_EXECUTABLE}" pack ${CPACK_NUGET_PACK_ADDITIONAL_OPTIONS}
                WORKING_DIRECTORY "${CPACK_TEMPORARY_DIRECTORY}"
              )
        endforeach()
    endif()
endif()

file(GLOB_RECURSE GEN_CPACK_OUTPUT_FILES "${CPACK_TEMPORARY_DIRECTORY}/*.nupkg")
if(NOT GEN_CPACK_OUTPUT_FILES)
    message(FATAL_ERROR "NuGet package was not generated at `${CPACK_TEMPORARY_DIRECTORY}`!")
endif()

_cpack_nuget_debug("Generated files: ${GEN_CPACK_OUTPUT_FILES}")
