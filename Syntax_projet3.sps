* Encoding: UTF-8.

SORT CASES  BY recuperation.
SPLIT FILE SEPARATE BY recuperation.

FREQUENCIES VARIABLES=sex myelopathy radiculopathy spondylolisthesis spinal_stenosis 
    foraminal_stenosis hernia narrow_canal nerve_damage smoke
  /ORDER=ANALYSIS.

DESCRIPTIVES VARIABLES=age CCL22 CRP NFL
  /STATISTICS=MEAN STDDEV.

SPLIT FILE OFF.

CROSSTABS
  /TABLES=sex myelopathy radiculopathy spondylolisthesis spinal_stenosis foraminal_stenosis hernia 
    narrow_canal nerve_damage smoke BY recuperation
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT 
  /COUNT ROUND CELL
  /METHOD=EXACT TIMER(5).

T-TEST GROUPS=recuperation('full' 'partial')
  /MISSING=ANALYSIS
  /VARIABLES=age CCL22 CRP NFL
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).


COMPUTE age_1=age / 10.
EXECUTE.

COMPUTE CCL22_1=CCL22 / 100.
EXECUTE.

COMPUTE CRP_1=CRP/10000.
EXECUTE.

COMPUTE NFL_1=NFL / 10.
EXECUTE.

RECODE recuperation ('full'=1) ('partial'=0) INTO recuperation_1.
EXECUTE.

LOGISTIC REGRESSION VARIABLES recuperation_1
  /METHOD=ENTER age_1 CCL22_1 CRP_1 NFL_1 
  /SAVE=PRED
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

ROC PRE_1 BY recuperation_1 (1)
  /PLOT=CURVE(REFERENCE)
  /PRINT=SE COORDINATES
  /CRITERIA=CUTOFF(INCLUDE) TESTPOS(LARGE) DISTRIBUTION(FREE) CI(95)
  /MISSING=EXCLUDE.

LOGISTIC REGRESSION VARIABLES recuperation_1
  /METHOD=ENTER age_1 CCL22_1 CRP_1 NFL_1 
  /SAVE=PRED
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.42).
