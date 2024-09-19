#TODO: fix <,>,| characters interpreted ad shell commands in cat
#!/bin/bash
# Check if a project name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project-name> [target-directory]"
    exit 1
fi

# Set project name and target directory
PROJECT_NAME=$1
TARGET_DIR=${2:-$(pwd)}

# Full path to the project directory
PROJECT_DIR="$TARGET_DIR/$PROJECT_NAME"

# Create directories
mkdir -p "$PROJECT_DIR/src"
mkdir -p "$PROJECT_DIR/obj"
mkdir -p "$PROJECT_DIR/include"
mkdir -p "$PROJECT_DIR/bin"

# Create a simple Makefile
cat <<EOL > "$PROJECT_DIR/Makefile"
# Compiler settings
CXX = g++
CXXFLAGS = -std=c++11 -Wall -g -Iinclude  # Added -Iinclude to include the header directory
#CXXFLAGS = -std=c++20 -Wall -Wextra -Wconversion -Wsign-conversion -pedantic -g -Iinclude

# Project settings
APPNAME = app
SRCDIR = src
OBJDIR = obj

# Automatically find all .cpp files in the source directory
SRC = \$(wildcard \$(SRCDIR)/*.cpp)

# Convert .cpp files to .o files
OBJ = \$(patsubst \$(SRCDIR)/%.cpp, \$(OBJDIR)/%.o, \$(SRC))

# Target: Build the application
all: \$(APPNAME)

# Linking the final executable
\$(APPNAME): \$(OBJ)
	\$(CXX) \$(CXXFLAGS) -o \$@ \$^

# Compiling .cpp files to .o files
\$(OBJDIR)/%.o: \$(SRCDIR)/%.cpp | \$(OBJDIR)
	\$(CXX) \$(CXXFLAGS) -c \$< -o \$@

# Create the obj directory if it doesn't exist
\$(OBJDIR):
	mkdir -p \$(OBJDIR)

# Clean the project
clean:
	rm -rf \$(OBJDIR) \$(APPNAME)

# Phony targets (don't correspond to actual files)
.PHONY: all clean
EOL

# Create a default main.cpp file
cat <<EOL > "$PROJECT_DIR/src/main.cpp"
#include <iostream>

int main() {
    std::cout << "Hello, $PROJECT_NAME!" << std::endl;
    return 0;
}
EOL

# Create simple compile_flags.txt to help clangd with include paths and other stuff
cat <<EOL > "$PROJECT_DIR/compile_flags.txt"
-Iinclude
EOL

# Create VS 2022 solution
cat <<EOL > "$PROJECT_DIR/$PROJECT_NAME.sln"
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio Version 17
VisualStudioVersion = 17.11.35303.130
MinimumVisualStudioVersion = 10.0.40219.1
Project("{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}") = "$PROJECT_NAME", "$PROJECT_NAME.vcxproj", "{27A64A19-79EE-4883-9C56-21B6CE2E284A}"
EndProject
Global
	GlobalSection(SolutionConfigurationPlatforms) = preSolution
		Debug|x64 = Debug|x64
		Debug|x86 = Debug|x86
		Release|x64 = Release|x64
		Release|x86 = Release|x86
	EndGlobalSection
	GlobalSection(ProjectConfigurationPlatforms) = postSolution
		{27A64A19-79EE-4883-9C56-21B6CE2E284A}.Debug|x64.ActiveCfg = Debug|x64
		{27A64A19-79EE-4883-9C56-21B6CE2E284A}.Debug|x64.Build.0 = Debug|x64
		{27A64A19-79EE-4883-9C56-21B6CE2E284A}.Debug|x86.ActiveCfg = Debug|Win32
		{27A64A19-79EE-4883-9C56-21B6CE2E284A}.Debug|x86.Build.0 = Debug|Win32
		{27A64A19-79EE-4883-9C56-21B6CE2E284A}.Release|x64.ActiveCfg = Release|x64
		{27A64A19-79EE-4883-9C56-21B6CE2E284A}.Release|x64.Build.0 = Release|x64
		{27A64A19-79EE-4883-9C56-21B6CE2E284A}.Release|x86.ActiveCfg = Release|Win32
		{27A64A19-79EE-4883-9C56-21B6CE2E284A}.Release|x86.Build.0 = Release|Win32
	EndGlobalSection
	GlobalSection(SolutionProperties) = preSolution
		HideSolutionNode = FALSE
	EndGlobalSection
	GlobalSection(ExtensibilityGlobals) = postSolution
		SolutionGuid = {837195A1-C5F5-4329-B6D7-F7C2352C9587}
	EndGlobalSection
EndGlobal
EOL

cat <<EOL > "$PROJECT_DIR/$PROJECT_NAME.vcxproj"
<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <ItemGroup Label="ProjectConfigurations">
    <ProjectConfiguration Include="Debug|Win32">
      <Configuration>Debug</Configuration>
      <Platform>Win32</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="Release|Win32">
      <Configuration>Release</Configuration>
      <Platform>Win32</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="Debug|x64">
      <Configuration>Debug</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="Release|x64">
      <Configuration>Release</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
  </ItemGroup>
  <PropertyGroup Label="Globals">
    <VCProjectVersion>17.0</VCProjectVersion>
    <ProjectGuid>{27A64A19-79EE-4883-9C56-21B6CE2E284A}</ProjectGuid>
    <Keyword>Win32Proj</Keyword>
    <WindowsTargetPlatformVersion>10.0</WindowsTargetPlatformVersion>
  </PropertyGroup>
  <Import Project="\$(VCTargetsPath)\Microsoft.Cpp.Default.props" />
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Debug|Win32'" Label="Configuration">
    <ConfigurationType>Application</ConfigurationType>
    <UseDebugLibraries>true</UseDebugLibraries>
    <PlatformToolset>v143</PlatformToolset>
  </PropertyGroup>
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Release|Win32'" Label="Configuration">
    <ConfigurationType>Application</ConfigurationType>
    <UseDebugLibraries>false</UseDebugLibraries>
    <PlatformToolset>v143</PlatformToolset>
  </PropertyGroup>
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Debug|x64'" Label="Configuration">
    <ConfigurationType>Application</ConfigurationType>
    <UseDebugLibraries>true</UseDebugLibraries>
    <PlatformToolset>v143</PlatformToolset>
  </PropertyGroup>
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Release|x64'" Label="Configuration">
    <ConfigurationType>Application</ConfigurationType>
    <UseDebugLibraries>false</UseDebugLibraries>
    <PlatformToolset>v143</PlatformToolset>
  </PropertyGroup>
  <Import Project="\$(VCTargetsPath)\Microsoft.Cpp.props" />
  <ImportGroup Label="ExtensionSettings">
  </ImportGroup>
  <ImportGroup Label="Shared">
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'\\$(Configuration)|\$(Platform)'=='Debug|Win32'">
    <Import Project="\$(UserRootDir)\Microsoft.Cpp.\$(Platform).user.props" Condition="exists('\$(UserRootDir)\Microsoft.Cpp.\$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'\$(Configuration)|\$(Platform)'=='Release|Win32'">
    <Import Project="\$(UserRootDir)\Microsoft.Cpp.\$(Platform).user.props" Condition="exists('\$(UserRootDir)\Microsoft.Cpp.\$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'\$(Configuration)|\$(Platform)'=='Debug|x64'">
    <Import Project="\$(UserRootDir)\Microsoft.Cpp.\$(Platform).user.props" Condition="exists('\$(UserRootDir)\Microsoft.Cpp.\$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'\$(Configuration)|\$(Platform)'=='Release|x64'">
    <Import Project="\$(UserRootDir)\Microsoft.Cpp.\$(Platform).user.props" Condition="exists('\$(UserRootDir)\Microsoft.Cpp.\$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <PropertyGroup Label="UserMacros" />
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Debug|Win32'">
    <LinkIncremental>true</LinkIncremental>
    <OutDir>\$(SolutionDir)bin\\\$(Platform)\\$(Configuration)\\</OutDir>
    <IntDir>\$(SolutionDir)int\\\$(Platform)\\$(Configuration)\\</IntDir>
  </PropertyGroup>
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Debug|x64'">
    <LinkIncremental>true</LinkIncremental>
    <OutDir>\$(SolutionDir)bin\\\$(Platform)\\\$(Configuration)\\</OutDir>
    <IntDir>\$(SolutionDir)int\\\$(Platform)\\\$(Configuration)\\</IntDir>
  </PropertyGroup>
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Release|Win32'">
    <LinkIncremental>true</LinkIncremental>
    <OutDir>\$(SolutionDir)bin\\\$(Platform)\\\$(Configuration)\\</OutDir>
    <IntDir>\$(SolutionDir)int\\\$(Platform)\\\$(Configuration)\\</IntDir>
  </PropertyGroup>
  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Release|x64'">
    <LinkIncremental>true</LinkIncremental>
    <OutDir>\$(SolutionDir)bin\\\$(Platform)\\\$(Configuration)\\</OutDir>
    <IntDir>\$(SolutionDir)int\\\$(Platform)\\\$(Configuration)\\</IntDir>
  </PropertyGroup>
  <ItemDefinitionGroup Condition="'\$(Configuration)|\$(Platform)'=='Debug|Win32'">
    <ClCompile>
      <PreprocessorDefinitions>WIN32;_DEBUG;_CONSOLE;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      <WarningLevel>Level3</WarningLevel>
      <AdditionalIncludeDirectories>\$(SolutionDir)include</AdditionalIncludeDirectories>
    </ClCompile>
    <Link>
      <GenerateDebugInformation>true</GenerateDebugInformation>
      <SubSystem>Console</SubSystem>
    </Link>
  </ItemDefinitionGroup>
  <ItemDefinitionGroup Condition="'\$(Configuration)|\$(Platform)'=='Debug|x64'">
    <ClCompile>
      <PreprocessorDefinitions>_DEBUG;_CONSOLE;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      <WarningLevel>Level3</WarningLevel>
      <AdditionalIncludeDirectories>\$(SolutionDir)include</AdditionalIncludeDirectories>
    </ClCompile>
    <Link>
      <GenerateDebugInformation>true</GenerateDebugInformation>
      <SubSystem>Console</SubSystem>
    </Link>
  </ItemDefinitionGroup>
  <ItemDefinitionGroup Condition="'\$(Configuration)|\$(Platform)'=='Release|Win32'">
    <ClCompile>
      <PreprocessorDefinitions>WIN32;NDEBUG;_CONSOLE;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      <WarningLevel>Level3</WarningLevel>
      <AdditionalIncludeDirectories>\$(SolutionDir)include</AdditionalIncludeDirectories>
    </ClCompile>
    <Link>
      <GenerateDebugInformation>true</GenerateDebugInformation>
      <SubSystem>Console</SubSystem>
      <EnableCOMDATFolding>true</EnableCOMDATFolding>
      <OptimizeReferences>true</OptimizeReferences>
    </Link>
  </ItemDefinitionGroup>
  <ItemDefinitionGroup Condition="'\$(Configuration)|\$(Platform)'=='Release|x64'">
    <ClCompile>
      <PreprocessorDefinitions>NDEBUG;_CONSOLE;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      <WarningLevel>Level3</WarningLevel>
      <AdditionalIncludeDirectories>\$(SolutionDir)include</AdditionalIncludeDirectories>
    </ClCompile>
    <Link>
      <GenerateDebugInformation>true</GenerateDebugInformation>
      <SubSystem>Console</SubSystem>
      <EnableCOMDATFolding>true</EnableCOMDATFolding>
      <OptimizeReferences>true</OptimizeReferences>
    </Link>
  </ItemDefinitionGroup>
  <ItemGroup>
    <ClCompile Include="src\\*.cpp" />
  </ItemGroup>
  <ItemGroup>
    <ClInclude Include="include\\*.hpp" />
  </ItemGroup>
  <Import Project="\$(VCTargetsPath)\\Microsoft.Cpp.targets" />
  <ImportGroup Label="ExtensionTargets">
  </ImportGroup>
</Project>
EOL

cat <<EOL > "$PROJECT_DIR/$PROJECT_NAME.vcxproj.filters"
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <ItemGroup>
    <Filter Include="Source Files">
      <UniqueIdentifier>{4FC737F1-C7A5-4376-A066-2A32D752A2FF}</UniqueIdentifier>
      <Extensions>cpp;c;cc;cxx;def;odl;idl;hpj;bat;asm;asmx</Extensions>
    </Filter>
    <Filter Include="Header Files">
      <UniqueIdentifier>{93995380-89BD-4b04-88EB-625FBE52EBFB}</UniqueIdentifier>
      <Extensions>h;hh;hpp;hxx;hm;inl;inc;xsd</Extensions>
    </Filter>
    <Filter Include="Resource Files">
      <UniqueIdentifier>{67DA6AB6-F800-4c08-8B7A-83BB121AAD01}</UniqueIdentifier>
      <Extensions>rc;ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe;resx;tiff;tif;png;wav</Extensions>
    </Filter>
  </ItemGroup>
  <ItemGroup>
    <ClCompile Include="src\\*.cpp">
      <Filter>Source Files</Filter>
    </ClCompile>
  </ItemGroup>
</Project>
EOL

cat <<EOL > "$PROJECT_DIR/$PROJECT_NAME.vcxproj.user"
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="Current" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup />
</Project>
EOL

# Print success message
echo "C++ project '$PROJECT_NAME' created successfully in '$PROJECT_DIR'."
