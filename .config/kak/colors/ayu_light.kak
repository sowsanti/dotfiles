evaluate-commands %sh{
    red=rgb:e7666a
    light_red=rgb:ee9295
    dark_red=rgb:be5046
    green=rgb:80ab24
    yellow=rgb:eba54d
    dark_yellow=rgb:f0bc7b
    blue=rgb:4196df
    purple=rgb:9870c3
    cyan=rgb:51b891
    white=rgb:c1c1c1
    black=rgb:010101
    comment_grey=rgb:7c8285
    gutter_fg_grey=rgb:4b5263
    cursor_grey=rgb:f8f8f8
    visual_grey=rgb:d7d7d7
    menu_grey=rgb:7c8285
    special_grey=rgb:ebebeb
    vertsplit=rgb:fcfcfc
    visual_black=default

    printf "%s\n" "
    # Code
    face global value      $yellow
    face global type       $yellow
    face global function   $blue
    face global variable   $blue
    face global identifier $blue
    face global string     $green
    face global error      rgb:c3bf9f+b
    face global keyword    $purple
    face global operator   $cyan
    face global attribute  rgb:eedc82
    face global comment    $comment_grey+i

    # #include <...>
    face global meta       $yellow

    # Markup
    face global title      $blue
    face global header     $cyan
    face global bold       $red
    face global italic     $yellow
    face global mono       $green
    face global block      $purple
    face global link       $cyan
    face global bullet     $cyan
    face global list       $yellow

    # Builtin
    face global Default            $white,default

    face global PrimarySelection   $black,$white+bfg
    face global SecondarySelection $black,$white+fg

    face global PrimaryCursor      $white,$purple+bfg
    face global SecondaryCursor    $black,$light_red+fg

    face global PrimaryCursorEol   $black,$green+fg
    face global SecondaryCursorEol $black,$green+fg

    face global LineNumbers        $gutter_fg_grey
    face global LineNumberCursor   $yellow,default+b

    # Bottom menu:
    # text + background
    face global MenuBackground     $white,$black
    face global MenuForeground     $black,$purple

    # completion menu info
    face global MenuInfo           $menu_grey,default+i

    # assistant, [+]
    face global Information        $white,$visual_grey

    face global Error              $white,$red
    face global StatusLine         $white,default

    # Status line
    face global StatusLineMode     $black,$purple      # insert, prompt, enter key ...
    face global StatusLineInfo     $white,$visual_grey # 1 sel
    face global StatusLineValue    $visual_grey,$green # param=value, reg=value. ex: \"ey
    face global StatusCursor       $white,$purple+bg

    face global Prompt             $purple,$black # :
    face global MatchingChar       $red+b         # (), {}
    face global BufferPadding      $gutter_fg_grey,default   # EOF tildas (~)

    # Whitespace characters
    face global Whitespace         $gutter_fg_grey,default
    "
}
