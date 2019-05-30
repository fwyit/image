#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.3
#description : 本脚本主要用来启动NODE项目

WEB=${WEB:=dist}
BAK=${BAK:=$WEB.bak}
export PATH=$PATH:./node_modules/.bin/

nbnpm config set color false
npm config set color false

NODE_ARGS="NODE_ENV=${NODE_ENV:=production} $NODE_ARG $NODE_ARGS"
echo "当前使用的环境变量为 $NODE_ARGS"

test -d $BAK && { rm -rf $BAK && echo "成功清理原有备份文件" || echo "清理备份文件失败$BAK"; }
test -d $WEB && mv $WEB $BAK

_default(){ test -e package.json && _nbnpm || _sh ;}
_nbnpm(){ nbnpm i && eval $NODE_ARGS nbnpm run build $BUILD_ARGS|| exit 2 ; }
_yarn(){ yarn install && yarn build $BUILD_ARGS || exit 2 ;}
_gulp(){ nbnpm i && eval $@ ; }
_npm(){ npm i && eval $NODE_ARGS npm run build $BUILD_ARGS|| exit 2 ; }
_sh(){ echo "准备直接进入容器..."; $@ ; exec sh; }

arg=$1 && shift

case $arg in
    npm|node)   _npm    ;;
    yarn)       _yarn   ;;
    sh)         _sh   $@;;
    gulp)       _gulp $@;; 
    nbnpm)      _nbnpm  ;;
    help|h)     _help   ;;
    *)          _default;;
esac

test "$?" -ne 0 && echo "前端编译失败，准备退出..." && exit 2
