//setBatchMode(true);
dir1 = getDirectory("Choose Source Directory for image to binarise"); //source image
index = lastIndexOf(dir1,"\\");
print(index);
tempdir = substring(dir1,0,index);
dir2 = tempdir+"_mask-test3/";
File.makeDirectory(dir2);
dir3 = tempdir+"_nucleusStat-test3/";
File.makeDirectory(dir3);
j = getFileList(dir1);
for (i=0; i<j.length; i++)
{
	open(dir1 + j[i]);
	title1=getTitle();
	index1 = lastIndexOf(title1, ".");
	title2 =  substring(title1,0,index1);
	print(title2);
	selectWindow(title1);
	run("Split Channels");
	close("C1-"+title2+".tif");
	close("C3-"+title2+".tif");
	selectWindow("C2-"+title2+".tif");
	run("Duplicate...", "duplicate");
	rename("background");
	getDimensions(width, height, channels, slices, frames);
	run("Median...", "radius=25 stack");
	run("Multiply...", "value=2 stack");
	selectWindow("C2-"+title2+".tif");
	rename("embryo");
	imageCalculator("Subtract create stack", "embryo","background");
	close("embryo");
	close("background");
	selectWindow("Result of embryo");
	run("Gaussian Blur 3D...", "x=2 y=2 z=2");
	run("Smooth", "stack");
	run("Smooth", "stack");
	setMinAndMax(0, 30000); 
	setOption("ScaleConversions", true);
	run("8-bit");
	run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=0 parameter_2=0 white stack");
	run("Make Binary", "method=Default background=Default create");
	close("Result of embryo");
	selectWindow("MASK_Result of embryo");
	run("Fill Holes", "stack");
	run("Options...", "iterations=2 count=3 do=Open stack");
	run("Watershed", "stack");
	title4 = getTitle();
	print(title4);
	run("3D Objects Counter", "threshold=128 slice=15 min.=100 max.=5000 objects statistics summary");
	selectWindow("Objects map of "+title4);
	title5 = getTitle();
	setThreshold(1, 255);
	run("Convert to Mask", "method=Default background=Dark create");
	selectWindow("MASK_"+title5);
	title6 = getTitle();
	selectWindow("Statistics for "+title4);
	saveAs("Results", dir3+"NucleusResults_"+title2+".csv");
	close("NucleusResults_"+title2+".csv");
	
	selectWindow(title6);
	saveAs("tiff", dir2+"NucleiBinary_"+title2+".tif");	
	run("Close All");
}
selectWindow("Log");
saveAs("Results", dir3+"LogFile.csv");
//setBatchMode(false);