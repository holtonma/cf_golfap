String.prototype.parseColor=function(){var A="#";if(this.slice(0,4)=="rgb("){var C=this.slice(4,this.length-1).split(",");var B=0;do{A+=parseInt(C[B]).toColorPart()}while(++B<3)}else{if(this.slice(0,1)=="#"){if(this.length==4){for(var B=1;B<4;B++){A+=(this.charAt(B)+this.charAt(B)).toLowerCase()}}if(this.length==7){A=this.toLowerCase()}}}return(A.length==7?A:(arguments[0]||this))};Element.collectTextNodes=function(A){return $A($(A).childNodes).collect(function(B){return(B.nodeType==3?B.nodeValue:(B.hasChildNodes()?Element.collectTextNodes(B):""))}).flatten().join("")};Element.collectTextNodesIgnoreClass=function(A,B){return $A($(A).childNodes).collect(function(C){return(C.nodeType==3?C.nodeValue:((C.hasChildNodes()&&!Element.hasClassName(C,B))?Element.collectTextNodesIgnoreClass(C,B):""))}).flatten().join("")};Element.setContentZoom=function(A,B){A=$(A);A.setStyle({fontSize:(B/100)+"em"});if(Prototype.Browser.WebKit){window.scrollBy(0,0)}return A};Element.getInlineOpacity=function(A){return $(A).style.opacity||""};Element.forceRerendering=function(A){try{A=$(A);var C=document.createTextNode(" ");A.appendChild(C);A.removeChild(C)}catch(B){}};Array.prototype.call=function(){var A=arguments;this.each(function(B){B.apply(this,A)})};var Effect={_elementDoesNotExistError:{name:"ElementDoesNotExistError",message:"The specified DOM element does not exist, but is required for this effect to operate"},tagifyText:function(A){if(typeof Builder=="undefined"){throw ("Effect.tagifyText requires including script.aculo.us' builder.js library")}var B="position:relative";if(Prototype.Browser.IE){B+=";zoom:1"}A=$(A);$A(A.childNodes).each(function(C){if(C.nodeType==3){C.nodeValue.toArray().each(function(D){A.insertBefore(Builder.node("span",{style:B},D==" "?String.fromCharCode(160):D),C)});Element.remove(C)}})},multiple:function(B,C){var E;if(((typeof B=="object")||(typeof B=="function"))&&(B.length)){E=B}else{E=$(B).childNodes}var A=Object.extend({speed:0.1,delay:0},arguments[2]||{});var D=A.delay;$A(E).each(function(G,F){new C(G,Object.extend(A,{delay:F*A.speed+D}))})},PAIRS:{"slide":["SlideDown","SlideUp"],"blind":["BlindDown","BlindUp"],"appear":["Appear","Fade"]},toggle:function(B,C){B=$(B);C=(C||"appear").toLowerCase();var A=Object.extend({queue:{position:"end",scope:(B.id||"global"),limit:1}},arguments[2]||{});Effect[B.visible()?Effect.PAIRS[C][1]:Effect.PAIRS[C][0]](B,A)}};var Effect2=Effect;Effect.Transitions={linear:Prototype.K,sinoidal:function(A){return(-Math.cos(A*Math.PI)/2)+0.5},reverse:function(A){return 1-A},flicker:function(A){var A=((-Math.cos(A*Math.PI)/4)+0.75)+Math.random()/4;return(A>1?1:A)},wobble:function(A){return(-Math.cos(A*Math.PI*(9*A))/2)+0.5},pulse:function(B,A){A=A||5;return(Math.round((B%(1/A))*A)==0?((B*A*2)-Math.floor(B*A*2)):1-((B*A*2)-Math.floor(B*A*2)))},none:function(A){return 0},full:function(A){return 1}};Effect.ScopedQueue=Class.create();Object.extend(Object.extend(Effect.ScopedQueue.prototype,Enumerable),{initialize:function(){this.effects=[];this.interval=null},_each:function(A){this.effects._each(A)},add:function(B){var C=new Date().getTime();var A=(typeof B.options.queue=="string")?B.options.queue:B.options.queue.position;switch(A){case"front":this.effects.findAll(function(D){return D.state=="idle"}).each(function(D){D.startOn+=B.finishOn;D.finishOn+=B.finishOn});break;case"with-last":C=this.effects.pluck("startOn").max()||C;break;case"end":C=this.effects.pluck("finishOn").max()||C;break}B.startOn+=C;B.finishOn+=C;if(!B.options.queue.limit||(this.effects.length<B.options.queue.limit)){this.effects.push(B)}if(!this.interval){this.interval=setInterval(this.loop.bind(this),15)}},remove:function(A){this.effects=this.effects.reject(function(B){return B==A});if(this.effects.length==0){clearInterval(this.interval);this.interval=null}},loop:function(){var C=new Date().getTime();for(var B=0,A=this.effects.length;B<A;B++){this.effects[B]&&this.effects[B].loop(C)}}});Effect.Queues={instances:$H(),get:function(A){if(typeof A!="string"){return A}if(!this.instances[A]){this.instances[A]=new Effect.ScopedQueue()}return this.instances[A]}};Effect.Queue=Effect.Queues.get("global");Effect.DefaultOptions={transition:Effect.Transitions.sinoidal,duration:1,fps:100,sync:false,from:0,to:1,delay:0,queue:"parallel"};Effect.Base=function(){};Effect.Base.prototype={position:null,start:function(options){function codeForEvent(options,eventName){return((options[eventName+"Internal"]?"this.options."+eventName+"Internal(this);":"")+(options[eventName]?"this.options."+eventName+"(this);":""))}if(options.transition===false){options.transition=Effect.Transitions.linear}this.options=Object.extend(Object.extend({},Effect.DefaultOptions),options||{});this.currentFrame=0;this.state="idle";this.startOn=this.options.delay*1000;this.finishOn=this.startOn+(this.options.duration*1000);this.fromToDelta=this.options.to-this.options.from;this.totalTime=this.finishOn-this.startOn;this.totalFrames=this.options.fps*this.options.duration;eval('this.render = function(pos){ if(this.state=="idle"){this.state="running";'+codeForEvent(options,"beforeSetup")+(this.setup?"this.setup();":"")+codeForEvent(options,"afterSetup")+'};if(this.state=="running"){pos=this.options.transition(pos)*'+this.fromToDelta+"+"+this.options.from+";this.position=pos;"+codeForEvent(options,"beforeUpdate")+(this.update?"this.update(pos);":"")+codeForEvent(options,"afterUpdate")+"}}");this.event("beforeStart");if(!this.options.sync){Effect.Queues.get(typeof this.options.queue=="string"?"global":this.options.queue.scope).add(this)}},loop:function(C){if(C>=this.startOn){if(C>=this.finishOn){this.render(1);this.cancel();this.event("beforeFinish");if(this.finish){this.finish()}this.event("afterFinish");return }var B=(C-this.startOn)/this.totalTime,A=Math.round(B*this.totalFrames);if(A>this.currentFrame){this.render(B);this.currentFrame=A}}},cancel:function(){if(!this.options.sync){Effect.Queues.get(typeof this.options.queue=="string"?"global":this.options.queue.scope).remove(this)}this.state="finished"},event:function(A){if(this.options[A+"Internal"]){this.options[A+"Internal"](this)}if(this.options[A]){this.options[A](this)}},inspect:function(){var A=$H();for(property in this){if(typeof this[property]!="function"){A[property]=this[property]}}return"#<Effect:"+A.inspect()+",options:"+$H(this.options).inspect()+">"}};Effect.Parallel=Class.create();Object.extend(Object.extend(Effect.Parallel.prototype,Effect.Base.prototype),{initialize:function(A){this.effects=A||[];this.start(arguments[1])},update:function(A){this.effects.invoke("render",A)},finish:function(A){this.effects.each(function(B){B.render(1);B.cancel();B.event("beforeFinish");if(B.finish){B.finish(A)}B.event("afterFinish")})}});Effect.Event=Class.create();Object.extend(Object.extend(Effect.Event.prototype,Effect.Base.prototype),{initialize:function(){var A=Object.extend({duration:0},arguments[0]||{});this.start(A)},update:Prototype.emptyFunction});Effect.Opacity=Class.create();Object.extend(Object.extend(Effect.Opacity.prototype,Effect.Base.prototype),{initialize:function(B){this.element=$(B);if(!this.element){throw (Effect._elementDoesNotExistError)}if(Prototype.Browser.IE&&(!this.element.currentStyle.hasLayout)){this.element.setStyle({zoom:1})}var A=Object.extend({from:this.element.getOpacity()||0,to:1},arguments[1]||{});this.start(A)},update:function(A){this.element.setOpacity(A)}});Effect.Move=Class.create();Object.extend(Object.extend(Effect.Move.prototype,Effect.Base.prototype),{initialize:function(B){this.element=$(B);if(!this.element){throw (Effect._elementDoesNotExistError)}var A=Object.extend({x:0,y:0,mode:"relative"},arguments[1]||{});this.start(A)},setup:function(){this.element.makePositioned();this.originalLeft=parseFloat(this.element.getStyle("left")||"0");this.originalTop=parseFloat(this.element.getStyle("top")||"0");if(this.options.mode=="absolute"){this.options.x=this.options.x-this.originalLeft;this.options.y=this.options.y-this.originalTop}},update:function(A){this.element.setStyle({left:Math.round(this.options.x*A+this.originalLeft)+"px",top:Math.round(this.options.y*A+this.originalTop)+"px"})}});Effect.MoveBy=function(B,A,C){return new Effect.Move(B,Object.extend({x:C,y:A},arguments[3]||{}))};Effect.Scale=Class.create();Object.extend(Object.extend(Effect.Scale.prototype,Effect.Base.prototype),{initialize:function(B,C){this.element=$(B);if(!this.element){throw (Effect._elementDoesNotExistError)}var A=Object.extend({scaleX:true,scaleY:true,scaleContent:true,scaleFromCenter:false,scaleMode:"box",scaleFrom:100,scaleTo:C},arguments[2]||{});this.start(A)},setup:function(){this.restoreAfterFinish=this.options.restoreAfterFinish||false;this.elementPositioning=this.element.getStyle("position");this.originalStyle={};["top","left","width","height","fontSize"].each(function(B){this.originalStyle[B]=this.element.style[B]}.bind(this));this.originalTop=this.element.offsetTop;this.originalLeft=this.element.offsetLeft;var A=this.element.getStyle("font-size")||"100%";["em","px","%","pt"].each(function(B){if(A.indexOf(B)>0){this.fontSize=parseFloat(A);this.fontSizeType=B}}.bind(this));this.factor=(this.options.scaleTo-this.options.scaleFrom)/100;this.dims=null;if(this.options.scaleMode=="box"){this.dims=[this.element.offsetHeight,this.element.offsetWidth]}if(/^content/.test(this.options.scaleMode)){this.dims=[this.element.scrollHeight,this.element.scrollWidth]}if(!this.dims){this.dims=[this.options.scaleMode.originalHeight,this.options.scaleMode.originalWidth]}},update:function(A){var B=(this.options.scaleFrom/100)+(this.factor*A);if(this.options.scaleContent&&this.fontSize){this.element.setStyle({fontSize:this.fontSize*B+this.fontSizeType})}this.setDimensions(this.dims[0]*B,this.dims[1]*B)},finish:function(A){if(this.restoreAfterFinish){this.element.setStyle(this.originalStyle)}},setDimensions:function(A,D){var E={};if(this.options.scaleX){E.width=Math.round(D)+"px"}if(this.options.scaleY){E.height=Math.round(A)+"px"}if(this.options.scaleFromCenter){var C=(A-this.dims[0])/2;var B=(D-this.dims[1])/2;if(this.elementPositioning=="absolute"){if(this.options.scaleY){E.top=this.originalTop-C+"px"}if(this.options.scaleX){E.left=this.originalLeft-B+"px"}}else{if(this.options.scaleY){E.top=-C+"px"}if(this.options.scaleX){E.left=-B+"px"}}}this.element.setStyle(E)}});Effect.Highlight=Class.create();Object.extend(Object.extend(Effect.Highlight.prototype,Effect.Base.prototype),{initialize:function(B){this.element=$(B);if(!this.element){throw (Effect._elementDoesNotExistError)}var A=Object.extend({startcolor:"#ffff99"},arguments[1]||{});this.start(A)},setup:function(){if(this.element.getStyle("display")=="none"){this.cancel();return }this.oldStyle={};if(!this.options.keepBackgroundImage){this.oldStyle.backgroundImage=this.element.getStyle("background-image");this.element.setStyle({backgroundImage:"none"})}if(!this.options.endcolor){this.options.endcolor=this.element.getStyle("background-color").parseColor("#ffffff")}if(!this.options.restorecolor){this.options.restorecolor=this.element.getStyle("background-color")}this._base=$R(0,2).map(function(A){return parseInt(this.options.startcolor.slice(A*2+1,A*2+3),16)}.bind(this));this._delta=$R(0,2).map(function(A){return parseInt(this.options.endcolor.slice(A*2+1,A*2+3),16)-this._base[A]}.bind(this))},update:function(A){this.element.setStyle({backgroundColor:$R(0,2).inject("#",function(B,C,D){return B+(Math.round(this._base[D]+(this._delta[D]*A)).toColorPart())}.bind(this))})},finish:function(){this.element.setStyle(Object.extend(this.oldStyle,{backgroundColor:this.options.restorecolor}))}});Effect.ScrollTo=Class.create();Object.extend(Object.extend(Effect.ScrollTo.prototype,Effect.Base.prototype),{initialize:function(A){this.element=$(A);this.start(arguments[1]||{})},setup:function(){Position.prepare();var B=Position.cumulativeOffset(this.element);if(this.options.offset){B[1]+=this.options.offset}var A=window.innerHeight?window.height-window.innerHeight:document.body.scrollHeight-(document.documentElement.clientHeight?document.documentElement.clientHeight:document.body.clientHeight);this.scrollStart=Position.deltaY;this.delta=(B[1]>A?A:B[1])-this.scrollStart},update:function(A){Position.prepare();window.scrollTo(Position.deltaX,this.scrollStart+(A*this.delta))}});Effect.Fade=function(C){C=$(C);var A=C.getInlineOpacity();var B=Object.extend({from:C.getOpacity()||1,to:0,afterFinishInternal:function(D){if(D.options.to!=0){return }D.element.hide().setStyle({opacity:A})}},arguments[1]||{});return new Effect.Opacity(C,B)};Effect.Appear=function(B){B=$(B);var A=Object.extend({from:(B.getStyle("display")=="none"?0:B.getOpacity()||0),to:1,afterFinishInternal:function(C){C.element.forceRerendering()},beforeSetup:function(C){C.element.setOpacity(C.options.from).show()}},arguments[1]||{});return new Effect.Opacity(B,A)};Effect.Puff=function(B){B=$(B);var A={opacity:B.getInlineOpacity(),position:B.getStyle("position"),top:B.style.top,left:B.style.left,width:B.style.width,height:B.style.height};return new Effect.Parallel([new Effect.Scale(B,200,{sync:true,scaleFromCenter:true,scaleContent:true,restoreAfterFinish:true}),new Effect.Opacity(B,{sync:true,to:0})],Object.extend({duration:1,beforeSetupInternal:function(C){Position.absolutize(C.effects[0].element)},afterFinishInternal:function(C){C.effects[0].element.hide().setStyle(A)}},arguments[1]||{}))};Effect.BlindUp=function(A){A=$(A);A.makeClipping();return new Effect.Scale(A,0,Object.extend({scaleContent:false,scaleX:false,restoreAfterFinish:true,afterFinishInternal:function(B){B.element.hide().undoClipping()}},arguments[1]||{}))};Effect.BlindDown=function(B){B=$(B);var A=B.getDimensions();return new Effect.Scale(B,100,Object.extend({scaleContent:false,scaleX:false,scaleFrom:0,scaleMode:{originalHeight:A.height,originalWidth:A.width},restoreAfterFinish:true,afterSetup:function(C){C.element.makeClipping().setStyle({height:"0px"}).show()},afterFinishInternal:function(C){C.element.undoClipping()}},arguments[1]||{}))};Effect.SwitchOff=function(B){B=$(B);var A=B.getInlineOpacity();return new Effect.Appear(B,Object.extend({duration:0.4,from:0,transition:Effect.Transitions.flicker,afterFinishInternal:function(C){new Effect.Scale(C.element,1,{duration:0.3,scaleFromCenter:true,scaleX:false,scaleContent:false,restoreAfterFinish:true,beforeSetup:function(D){D.element.makePositioned().makeClipping()},afterFinishInternal:function(D){D.element.hide().undoClipping().undoPositioned().setStyle({opacity:A})}})}},arguments[1]||{}))};Effect.DropOut=function(B){B=$(B);var A={top:B.getStyle("top"),left:B.getStyle("left"),opacity:B.getInlineOpacity()};return new Effect.Parallel([new Effect.Move(B,{x:0,y:100,sync:true}),new Effect.Opacity(B,{sync:true,to:0})],Object.extend({duration:0.5,beforeSetup:function(C){C.effects[0].element.makePositioned()},afterFinishInternal:function(C){C.effects[0].element.hide().undoPositioned().setStyle(A)}},arguments[1]||{}))};Effect.Shake=function(B){B=$(B);var A={top:B.getStyle("top"),left:B.getStyle("left")};return new Effect.Move(B,{x:20,y:0,duration:0.05,afterFinishInternal:function(C){new Effect.Move(C.element,{x:-40,y:0,duration:0.1,afterFinishInternal:function(D){new Effect.Move(D.element,{x:40,y:0,duration:0.1,afterFinishInternal:function(E){new Effect.Move(E.element,{x:-40,y:0,duration:0.1,afterFinishInternal:function(F){new Effect.Move(F.element,{x:40,y:0,duration:0.1,afterFinishInternal:function(G){new Effect.Move(G.element,{x:-20,y:0,duration:0.05,afterFinishInternal:function(H){H.element.undoPositioned().setStyle(A)}})}})}})}})}})}})};Effect.SlideDown=function(C){C=$(C).cleanWhitespace();var A=C.down().getStyle("bottom");var B=C.getDimensions();return new Effect.Scale(C,100,Object.extend({scaleContent:false,scaleX:false,scaleFrom:window.opera?0:1,scaleMode:{originalHeight:B.height,originalWidth:B.width},restoreAfterFinish:true,afterSetup:function(D){D.element.makePositioned();D.element.down().makePositioned();if(window.opera){D.element.setStyle({top:""})}D.element.makeClipping().setStyle({height:"0px"}).show()},afterUpdateInternal:function(D){D.element.down().setStyle({bottom:(D.dims[0]-D.element.clientHeight)+"px"})},afterFinishInternal:function(D){D.element.undoClipping().undoPositioned();D.element.down().undoPositioned().setStyle({bottom:A})}},arguments[1]||{}))};Effect.SlideUp=function(B){B=$(B).cleanWhitespace();var A=B.down().getStyle("bottom");return new Effect.Scale(B,window.opera?0:1,Object.extend({scaleContent:false,scaleX:false,scaleMode:"box",scaleFrom:100,restoreAfterFinish:true,beforeStartInternal:function(C){C.element.makePositioned();C.element.down().makePositioned();if(window.opera){C.element.setStyle({top:""})}C.element.makeClipping().show()},afterUpdateInternal:function(C){C.element.down().setStyle({bottom:(C.dims[0]-C.element.clientHeight)+"px"})},afterFinishInternal:function(C){C.element.hide().undoClipping().undoPositioned().setStyle({bottom:A});C.element.down().undoPositioned()}},arguments[1]||{}))};Effect.Squish=function(A){return new Effect.Scale(A,window.opera?1:0,{restoreAfterFinish:true,beforeSetup:function(B){B.element.makeClipping()},afterFinishInternal:function(B){B.element.hide().undoClipping()}})};Effect.Grow=function(C){C=$(C);var B=Object.extend({direction:"center",moveTransition:Effect.Transitions.sinoidal,scaleTransition:Effect.Transitions.sinoidal,opacityTransition:Effect.Transitions.full},arguments[1]||{});var A={top:C.style.top,left:C.style.left,height:C.style.height,width:C.style.width,opacity:C.getInlineOpacity()};var G=C.getDimensions();var H,F;var E,D;switch(B.direction){case"top-left":H=F=E=D=0;break;case"top-right":H=G.width;F=D=0;E=-G.width;break;case"bottom-left":H=E=0;F=G.height;D=-G.height;break;case"bottom-right":H=G.width;F=G.height;E=-G.width;D=-G.height;break;case"center":H=G.width/2;F=G.height/2;E=-G.width/2;D=-G.height/2;break}return new Effect.Move(C,{x:H,y:F,duration:0.01,beforeSetup:function(I){I.element.hide().makeClipping().makePositioned()},afterFinishInternal:function(I){new Effect.Parallel([new Effect.Opacity(I.element,{sync:true,to:1,from:0,transition:B.opacityTransition}),new Effect.Move(I.element,{x:E,y:D,sync:true,transition:B.moveTransition}),new Effect.Scale(I.element,100,{scaleMode:{originalHeight:G.height,originalWidth:G.width},sync:true,scaleFrom:window.opera?1:0,transition:B.scaleTransition,restoreAfterFinish:true})],Object.extend({beforeSetup:function(J){J.effects[0].element.setStyle({height:"0px"}).show()},afterFinishInternal:function(J){J.effects[0].element.undoClipping().undoPositioned().setStyle(A)}},B))}})};Effect.Shrink=function(C){C=$(C);var B=Object.extend({direction:"center",moveTransition:Effect.Transitions.sinoidal,scaleTransition:Effect.Transitions.sinoidal,opacityTransition:Effect.Transitions.none},arguments[1]||{});var A={top:C.style.top,left:C.style.left,height:C.style.height,width:C.style.width,opacity:C.getInlineOpacity()};var F=C.getDimensions();var E,D;switch(B.direction){case"top-left":E=D=0;break;case"top-right":E=F.width;D=0;break;case"bottom-left":E=0;D=F.height;break;case"bottom-right":E=F.width;D=F.height;break;case"center":E=F.width/2;D=F.height/2;break}return new Effect.Parallel([new Effect.Opacity(C,{sync:true,to:0,from:1,transition:B.opacityTransition}),new Effect.Scale(C,window.opera?1:0,{sync:true,transition:B.scaleTransition,restoreAfterFinish:true}),new Effect.Move(C,{x:E,y:D,sync:true,transition:B.moveTransition})],Object.extend({beforeStartInternal:function(G){G.effects[0].element.makePositioned().makeClipping()},afterFinishInternal:function(G){G.effects[0].element.hide().undoClipping().undoPositioned().setStyle(A)}},B))};Effect.Pulsate=function(C){C=$(C);var B=arguments[1]||{};var A=C.getInlineOpacity();var E=B.transition||Effect.Transitions.sinoidal;var D=function(F){return E(1-Effect.Transitions.pulse(F,B.pulses))};D.bind(E);return new Effect.Opacity(C,Object.extend(Object.extend({duration:2,from:0,afterFinishInternal:function(F){F.element.setStyle({opacity:A})}},B),{transition:D}))};Effect.Fold=function(B){B=$(B);var A={top:B.style.top,left:B.style.left,width:B.style.width,height:B.style.height};B.makeClipping();return new Effect.Scale(B,5,Object.extend({scaleContent:false,scaleX:false,afterFinishInternal:function(C){new Effect.Scale(B,1,{scaleContent:false,scaleY:false,afterFinishInternal:function(D){D.element.hide().undoClipping().setStyle(A)}})}},arguments[1]||{}))};Effect.Morph=Class.create();Object.extend(Object.extend(Effect.Morph.prototype,Effect.Base.prototype),{initialize:function(C){this.element=$(C);if(!this.element){throw (Effect._elementDoesNotExistError)}var B=Object.extend({style:{}},arguments[1]||{});if(typeof B.style=="string"){if(B.style.indexOf(":")==-1){var D="",A="."+B.style;$A(document.styleSheets).reverse().each(function(E){if(E.cssRules){cssRules=E.cssRules}else{if(E.rules){cssRules=E.rules}}$A(cssRules).reverse().each(function(F){if(A==F.selectorText){D=F.style.cssText;throw $break}});if(D){throw $break}});this.style=D.parseStyle();B.afterFinishInternal=function(E){E.element.addClassName(E.options.style);E.transforms.each(function(F){if(F.style!="opacity"){E.element.style[F.style]=""}})}}else{this.style=B.style.parseStyle()}}else{this.style=$H(B.style)}this.start(B)},setup:function(){function A(B){if(!B||["rgba(0, 0, 0, 0)","transparent"].include(B)){B="#ffffff"}B=B.parseColor();return $R(0,2).map(function(C){return parseInt(B.slice(C*2+1,C*2+3),16)})}this.transforms=this.style.map(function(G){var F=G[0],E=G[1],D=null;if(E.parseColor("#zzzzzz")!="#zzzzzz"){E=E.parseColor();D="color"}else{if(F=="opacity"){E=parseFloat(E);if(Prototype.Browser.IE&&(!this.element.currentStyle.hasLayout)){this.element.setStyle({zoom:1})}}else{if(Element.CSS_LENGTH.test(E)){var C=E.match(/^([\+\-]?[0-9\.]+)(.*)$/);E=parseFloat(C[1]);D=(C.length==3)?C[2]:null}}}var B=this.element.getStyle(F);return{style:F.camelize(),originalValue:D=="color"?A(B):parseFloat(B||0),targetValue:D=="color"?A(E):E,unit:D}}.bind(this)).reject(function(B){return((B.originalValue==B.targetValue)||(B.unit!="color"&&(isNaN(B.originalValue)||isNaN(B.targetValue))))})},update:function(A){var D={},B,C=this.transforms.length;while(C--){D[(B=this.transforms[C]).style]=B.unit=="color"?"#"+(Math.round(B.originalValue[0]+(B.targetValue[0]-B.originalValue[0])*A)).toColorPart()+(Math.round(B.originalValue[1]+(B.targetValue[1]-B.originalValue[1])*A)).toColorPart()+(Math.round(B.originalValue[2]+(B.targetValue[2]-B.originalValue[2])*A)).toColorPart():B.originalValue+Math.round(((B.targetValue-B.originalValue)*A)*1000)/1000+B.unit}this.element.setStyle(D,true)}});Effect.Transform=Class.create();Object.extend(Effect.Transform.prototype,{initialize:function(A){this.tracks=[];this.options=arguments[1]||{};this.addTracks(A)},addTracks:function(A){A.each(function(B){var C=$H(B).values().first();this.tracks.push($H({ids:$H(B).keys().first(),effect:Effect.Morph,options:{style:C}}))}.bind(this));return this},play:function(){return new Effect.Parallel(this.tracks.map(function(A){var B=[$(A.ids)||$$(A.ids)].flatten();return B.map(function(C){return new A.effect(C,Object.extend({sync:true},A.options))})}).flatten(),this.options)}});Element.CSS_PROPERTIES=$w("backgroundColor backgroundPosition borderBottomColor borderBottomStyle borderBottomWidth borderLeftColor borderLeftStyle borderLeftWidth borderRightColor borderRightStyle borderRightWidth borderSpacing borderTopColor borderTopStyle borderTopWidth bottom clip color fontSize fontWeight height left letterSpacing lineHeight marginBottom marginLeft marginRight marginTop markerOffset maxHeight maxWidth minHeight minWidth opacity outlineColor outlineOffset outlineWidth paddingBottom paddingLeft paddingRight paddingTop right textIndent top width wordSpacing zIndex");Element.CSS_LENGTH=/^(([\+\-]?[0-9\.]+)(em|ex|px|in|cm|mm|pt|pc|\%))|0$/;String.prototype.parseStyle=function(){var B=document.createElement("div");B.innerHTML='<div style="'+this+'"></div>';var C=B.childNodes[0].style,A=$H();Element.CSS_PROPERTIES.each(function(D){if(C[D]){A[D]=C[D]}});if(Prototype.Browser.IE&&this.indexOf("opacity")>-1){A.opacity=this.match(/opacity:\s*((?:0|1)?(?:\.\d*)?)/)[1]}return A};Element.morph=function(A,B){new Effect.Morph(A,Object.extend({style:B},arguments[2]||{}));return A};["getInlineOpacity","forceRerendering","setContentZoom","collectTextNodes","collectTextNodesIgnoreClass","morph"].each(function(A){Element.Methods[A]=Element[A]});Element.Methods.visualEffect=function(B,C,A){s=C.dasherize().camelize();effect_class=s.charAt(0).toUpperCase()+s.substring(1);new Effect[effect_class](B,A);return $(B)};Element.addMethods()