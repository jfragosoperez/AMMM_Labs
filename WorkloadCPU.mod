/*********************************************
 * OPL 12.5.1.0 Model
 * Author: 1127051
 * Creation Date: 29/09/2014 at 10:36:52
 *********************************************/
//Variables
int nTasks=...;
int nCPUs=...;
range T=1..nTasks;
range C=1..nCPUs;
float rt[t in T]=...;
float rc[c in C]=...;
dvar float+ x_tc[t in T, c in C];
dvar float+ z;


// Objective
minimize z;
subject to{
	// Constraint 1
	forall(t in T)
	sum(c in C) x_tc[t,c] == 1;
	// Constraint 2
	forall(c in C)
	sum(t in T) rt[t]* x_tc[t,c] <= rc[c];
	// Constraint 3
	forall(c in C)
	z >= (1/rc[c])*sum(t in T) rt[t]* x_tc[t,c];
}

//Pre-processing block
execute {
	var totalLoad=0;
	for (var t=1;t<=nTasks;t++)
	totalLoad += rt[t];
	writeln("Total load "+ totalLoad);
};

//Post-processing block
execute {
	for (var c=1;c<=nCPUs;c++) {
		var load=0;
		for (var t=1;t<=nTasks;t++)
		load+=(rt[t]* x_tc[t][c]);
		load = (1/rc[c])*load;
		writeln("CPU " + c + " loaded at " + load + "%");
	}
};


//Main
/*
main {
	var src = new IloOplModelSource("P1.mod");
	var def = new IloOplModelDefinition(src);
	var cplex = new IloCplex();
	var model = new IloOplModel(def,cplex);
	var data = new IloOplDataSource("P1.dat");
	model.addDataSource(data);
	model.generate();
	cplex.epgap=0.01;
	if (cplex.solve()) {
		writeln("Max load " + cplex.getObjValue() + "%");
		for (var c=1;c<=model.nCPUs;c++) {
			var load=0;
			for (var t=1;t<=model.nTasks;t++)
			load+=(model.rt[t]* model.x_tc[t][c]);
			load = (1/model.rc[c])*load;
			writeln("CPU " + c + " loaded at " + load + "%");
		}		
	}
	else {
		writeln("Not solution found");
	}  
	
	model.end();
	data.end();
	def.end();
	cplex.end();
	src.end();
};*/