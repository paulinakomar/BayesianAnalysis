        
function myCallbackFunction(hProp,eventData)    %#ok - hProp is unused
   hAxes = eventData.AffectedObject;
   tickValues = get(hAxes,'YTick');
   newLabels = arrayfun(@(value)(sprintf('%.1f',value)), tickValues, 'UniformOutput',false);
   set(hAxes, 'YTickLabel', newLabels);
end  % myCallbackFunction



%         hhAxes = handle(gca);  % hAxes is the Matlab handle of our axes
%         hProp = findprop(hhAxes,'YTick');  % a schema.prop object
%         hListener = handle.listener(hhAxes, hProp, 'PropertyPostSet', @myCallbackFunction);
%         setappdata(gca, 'YTickListener', hListener);