## Writing the objective function
##
## Enio Gjerga, 2020

write_objective_function <- function(dataMatrix = dataMatrix, 
                                     variables = variables, 
                                     alphaWeight=alphaWeight, 
                                     betaWeight=betaWeight, 
                                     scores = scores, 
                                     measWeights = measWeights, 
                                     conditionIDX = conditionIDX ){

  if(is.null(scores)){

    measured <- gsub(colnames(dataMatrix$dataMatrix)[dataMatrix$dsID], 
                     pattern = "DS:", replacement = "")

    idxMeasured <- c()
    for(i in seq_len(length(measured))){

      idxMeasured <- c(idxMeasured, 
                       which(variables$expNodesReduced==paste0("Species ", 
                                                               measured[i])))

    }

    measuredVar <- variables$variables[idxMeasured]

    allWeights <- rep(x = 0, length(measuredVar))

    if(!is.null(measWeights)){

      weightedSpecies <- rownames(measWeights)

      for(i in seq_len(length(weightedSpecies))){

        allWeights[which(
          which(
            variables$expNodesReduced==
              paste0("Species ", 
                     weightedSpecies[i]))==idxMeasured)] <- measWeights[i]

      }

      objectiveFunctionVec <- paste0(" + ", allWeights, " absDiff", 
                                     gsub(measuredVar, pattern = "xb", 
                                          replacement = ""))

    } else {

      objectiveFunctionVec <- paste0(" + ", alphaWeight, " absDiff", 
                                     gsub(measuredVar, pattern = "xb", 
                                          replacement = ""))

    }

    objectiveFunction <- paste(objectiveFunctionVec, collapse = "")

    objectiveFunction <- substring(text = objectiveFunction[1], first = 4, 
                                   last = nchar(objectiveFunction))

    objectiveFunction <- paste0("", objectiveFunction)

    objectiveFunctionUpVec <- paste0(" + ", betaWeight, " ", 
                                     variables$variables[variables$idxNodesUp])
    objectiveFunctionUp <- paste(objectiveFunctionUpVec, collapse = "")

    objectiveFunctionDownVec <- 
      paste0(" + ", betaWeight, " ", 
             variables$variables[variables$idxNodesDown])
    objectiveFunctionDown <- paste(objectiveFunctionDownVec, collapse = "")

    objectiveFunction <- paste0(objectiveFunction, objectiveFunctionUp)
    objectiveFunction <- paste0(objectiveFunction, objectiveFunctionDown)

    return(objectiveFunction)

  } else {

    measured <- gsub(colnames(dataMatrix$dataMatrix)[dataMatrix$dsID], 
                     pattern = "DS:", replacement = "")

    idxMeasured <- c()
    for(i in seq_len(length(measured))){

      idxMeasured <- c(idxMeasured, 
                       which(variables$expNodesReduced==paste0("Species ", 
                                                               measured[i])))

    }

    measuredVar <- variables$variables[idxMeasured]

    allWeights <- rep(x = 0, length(measuredVar))

    if(!is.null(measWeights)){

      weightedSpecies <- rownames(measWeights)

      for(i in seq_len(length(weightedSpecies))){

        allWeights[which(
          which(
            variables$expNodesReduced==
              paste0("Species ", 
                     weightedSpecies[i]))==idxMeasured)] <- measWeights[i]

      }

      objectiveFunctionVec <- 
        paste0(" + ", allWeights, " absDiff", 
               gsub(measuredVar, pattern = "xb", replacement = ""))

    } else {

      objectiveFunctionVec <- 
        paste0(" + ", alphaWeight, " absDiff", 
               gsub(measuredVar, pattern = "xb", replacement = ""))

    }

    objectiveFunction <- paste(objectiveFunctionVec, collapse = "")

    objectiveFunction <- substring(text = objectiveFunction[1], first = 4, 
                                   last = nchar(objectiveFunction))

    objectiveFunction <- paste0("", objectiveFunction)

    betaValPos <- rep(betaWeight, length(variables$idxNodesUp))
    betaValNeg <- rep(betaWeight, length(variables$idxNodesDown))

    #
    idxPos <- which(scores[1, ] >= 0)
    if(length(idxPos) > 0){

      speciesPos <- colnames(scores)[idxPos]

      for(ii in seq_len(length(speciesPos))){

        currPos <- speciesPos[ii]

        idx <- 
          which(variables$exp[variables$idxNodesUp]==paste0("SpeciesUP ", 
                                                            currPos, 
                                                            " in experiment ", 
                                                            conditionIDX))
        betaValPos[idx] <- betaWeight*(1-scores[1, idxPos[ii]])

        idx <- 
          which(variables$exp[variables$idxNodesDown]==paste0("SpeciesDown ", 
                                                              currPos, 
                                                              " in experiment ",
                                                              conditionIDX))
        betaValNeg[idx] <- betaWeight*(1+scores[1, idxPos[ii]])

      }

    }

    #
    idxNeg <- which(scores[1, ] < 0)
    if(length(idxNeg) > 0){

      speciesNeg <- colnames(scores)[idxNeg]

      for(ii in seq_len(length(speciesNeg))){

        currNeg <- speciesNeg[ii]

        idx <- 
          which(variables$exp[variables$idxNodesUp]==paste0("SpeciesUP ",
                                                            currNeg, 
                                                            " in experiment ", 
                                                            conditionIDX))
        betaValPos[idx] <- betaWeight*(1-scores[1, idxNeg[ii]])

        idx <- 
          which(variables$exp[variables$idxNodesDown]==paste0("SpeciesDown ", 
                                                              currNeg, 
                                                              " in experiment ",
                                                              conditionIDX))
        betaValNeg[idx] <- betaWeight*(1+scores[1, idxNeg[ii]])

      }

    }

    objectiveFunctionUpVec <- 
      paste0(" + ", betaValPos, " ", variables$variables[variables$idxNodesUp])
    objectiveFunctionUp <- paste(objectiveFunctionUpVec, collapse = "")

    objectiveFunctionDownVec <- 
      paste0(" + ", betaValNeg, " ", 
             variables$variables[variables$idxNodesDown])
    objectiveFunctionDown <- paste(objectiveFunctionDownVec, collapse = "")

    objectiveFunction <- paste0(objectiveFunction, objectiveFunctionUp)
    objectiveFunction <- paste0(objectiveFunction, objectiveFunctionDown)

    return(objectiveFunction)

  }

}
