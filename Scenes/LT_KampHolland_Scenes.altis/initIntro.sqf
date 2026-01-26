
enableSaving [ false, false ];
[
    //--- RandomPos1
    {
        ["InitDummy",["Altis",[26858.9,24452.7,1.97391],298.859,0.7,[-17.2835,0],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
    },
    //--- SpawnPos
    {
        ["InitDummy",["Altis",[26765.7,24645.4,1.95978],130.829,0.7,[-12.1251,0.558511],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
        setviewdistance 200;
    },
    //--- SpawnPosHigh
    {
        ["InitDummy",["Altis",[26771.6,24637.1,11.5546],155.638,0.75,[-16.3852,0],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
    },
    //--- Briefing
    {
        ["InitDummy",["Altis",[26788.2,24625.8,1.29265],126.605,0.7,[-12.181,0],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
    },
    //--- RandomPos2
    {
        ["InitDummy",["Altis",[26836.9,24501.4,11.5404],22.0704,0.7,[-14.5345,0],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
    },
    //--- Medic-Training
    {
        ["InitDummy",["Altis",[26769,24590.7,2.48521],2.77914,0.7,[-29.4467,0],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
    },
    //--- AT-Firing
    {
        ["InitDummy",["Altis",[26778.6,24558.3,5.20821],75.0377,0.7,[-24.2605,0],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
    },
    //--- APC-Firing
    {
        ["InitDummy",["Altis",[26811,24458,2.38312],22.2303,0.7,[-18.8749,0],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
    },
    //--- RandomPos3
    {
        ["InitDummy",["Altis",[26731.2,24617.5,5.75008],101.225,0.7,[-14.4763,0],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
    },
    //--- AR Baan
    {
        ["InitDummy",["Altis",[26833.3,24520.3,4.44752],219.95,0.75,[-12.3396,0],0,0,720,0.3,1,1,0,1]] call bis_fnc_camera;
    }
] call BIS_fnc_initWorldScene;