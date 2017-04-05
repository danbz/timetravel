var processingInstance;

function setProcessingMouse(event){
   if (!processingInstance) {
      processingInstance = Processing.getInstanceById('dilationInterface');
   }
   
   var x = event.touches[0].pageX;
   var y = event.touches[0].pageY;

   processingInstance.mouseX = x;
   processingInstance.mouseY = y;
}

function touchStart(event) {
   event.preventDefault();
   //setProcessingMouse(event);
   //processingInstance.mousePressed();
}

function touchMove(event) {
   event.preventDefault();
   setProcessingMouse(event);
   processingInstance.mouseDragged();
}

function touchEnd(event) {
   event.preventDefault();
   //setProcessingMouse(event);
   //processingInstance.mouseReleased();
}

function touchCancel(event) {
   event.preventDefault();
   //setProcessingMouse(event);
   //processingInstance.mouseReleased();
}