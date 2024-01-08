# WorkloadRun API


## Conditions

There are three conditions in a WorkloadRun:
1. PipelinesSucceeded
2. ResumptionsSucceeded
3. Succeeded (Top Level)

### PipelinesSucceeded

If any pipeline has failed, this will show False

If any is still running, this will show Unknown

If all are successful, this will show True

### ResumptionsSucceeded
If any resumption has failed, this will show False

If any is still running, this will show Unknown

If all are successful, this will show True

### Succeeded

Follows the [Succeeded top level rule](./common.hbs.md#succeeded-top-level-condition)

The Succeeded condition reflects whichever is the least-desirable condition from [PipelinesSucceeded](#pipelinessucceeded) or 
[ResumptionsSuceeded](#resumptionssucceeded). 

Least desirable to most desirable state is:

* False
* Unknown
* True

This implies that any failure will show regardless of remaining runs... (todo: this might be wrong...)