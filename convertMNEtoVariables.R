#' Convert MNE Values into Common Derived Variables
#'
#' This function processes the Minimum Number of Elements (MNE) data to compute common derived variables
#' used in taphonomic analysis. These variables include Mean Number of Individuals (MNI), Abundance,
#' Mean Abundance (MA), Mean Part Abundance (MPA), Minimum Animal Units (MAU), Minimum Number of Anatomic Units (MNAU),
#' their respective percentages and cumulative values, and a bone level vector summarizing the skeletal sections.
#'
#' @param MNE A vector or dataframe column containing the Minimum Number of Elements for each skeletal part.
#' @param skeleton A dataframe specifying the expected number of each skeletal element in one complete skeleton
#' (One_Skeleton) and the corresponding skeletal part names (Elements).
#' @param individuals Optional. The total number of individuals estimated in the assemblage. If not provided,
#' it is calculated based on MNE and skeleton data.
#'
#' @details The function calculates various key taphonomic metrics from the provided MNE data. It checks for
#' consistency in the length of the MNE vector against the skeleton dataframe, ensuring accurate calculations.
#' If the `individuals` argument is not provided, it computes an MNI based on the ceiling of the ratio of MNE
#' to the expected number per skeleton, using this to calculate abundance and related metrics.
#'
#' Additionally, the function calculates a bone level vector using the \code{\link{summarize_bone_sections}}
#' function, which summarizes the minimum levels of different skeletal sections.
#'
#' @return A list containing:
#' \item{MNE}{The input vector of Minimum Number of Elements for each skeletal part.}
#' \item{Elements}{The names of skeletal parts as specified in the skeleton dataframe.}
#' \item{abundance}{The calculated abundance for each skeletal element.}
#' \item{MNI}{The Mean Number of Individuals estimated in the assemblage.}
#' \item{MAU}{Minimum Animal Units for each skeletal element.}
#' \item{MNAU}{Minimum Number of Anatomic Units for each skeletal element.}
#' \item{PercentMAU}{The percentage of MAU for each skeletal element.}
#' \item{PercentMNAU}{The percentage of MNAU for each skeletal element.}
#' \item{ReMNAU}{Relative MNAU for each skeletal element.}
#' \item{AcReMNAU}{Cumulative sum of ReMNAU.}
#' \item{MeanAbundance}{Overall mean abundance across all skeletal elements.}
#' \item{MeanPartAbundance}{Mean part abundance across all skeletal elements.}
#' \item{bone_level}{A vector summarizing the minimum levels for each skeletal section calculated using \code{\link{summarize_bone_sections}}.}
#'
#' @examples
#' # Assuming 'MNE' contains your MNE data and 'skeleton' describes the expected numbers
#' MNE <- data.frame(MNE = c(6, 4, 5, 3))
#' skeleton <- data.frame(
#'   Elements = c("Cranium", "Mandible", "Maxillae", "Hyoid"),
#'   One_Skeleton = c(1, 1, 1, 1),
#'   Skeleton_Section = c("Skull", "Skull", "Skull", "Hyoid")
#' )
#'
#' # Conduct the analysis
#' analysisResults <- convertMNEtoVariables(MNE, skeleton)
#'
#' # Access and view the results
#' print(analysisResults)
#'
#' @export
convertMNEtoVariables <- function(MNE, skeleton, individuals = NULL) {

  if (length(MNE) != nrow(skeleton)) {
    stop("Length of MNE vector must match the number of skeletal elements")
  }

  # Convert MNE to a data frame if it's not already
  if (!is.data.frame(MNE)) {
    MNE <- as.data.frame(MNE)
  }

  Elements <- skeleton$element

  # Calculate MNI and Individuals if not provided
  if (is.null(individuals)) {
    MNI <- ceiling(MNE$MNE / skeleton$count)
    individuals <- max(MNI)
  }

  # Compute Abundance for each part
  abundance <- MNE$MNE / (skeleton$count * individuals)

  # Compute Mean Abundance (MA)
  ma <- sum(MNE$MNE, na.rm = TRUE) / (sum(skeleton$count, na.rm = TRUE) * individuals)

  # Compute Mean Part Abundance (MPA)
  mpa <- sum(abundance, na.rm = TRUE) / length(abundance)

  # Additional metrics calculations
  MAU <- abundance
  MNAU <- abundance
  PMAU <- MAU / max(MNE$MNE / skeleton$count)
  PMNAU <- MNAU / individuals
  ReMNAU <- MNAU / sum(MNAU, na.rm = TRUE)

  # Calculate Accumulative ReMNAU
  AcReMNAU <- cumsum(ReMNAU)

  # Bone level vector calculation using summarize_bone_sections
  bone_info_df <- data.frame(element = skeleton$element, count = MNE$MNE)
  bone_level <- summarize_bone_sections(bone_info_df)

  # Return a list of all calculated metrics
  return(list(
    MNE = as.vector(MNE$MNE),
    Elements = Elements,
    abundance = abundance,
    MNI = individuals,
    MAU = MAU,
    MNAU = MNAU,
    PercentMAU = PMAU,
    PercentMNAU = PMNAU,
    ReMNAU = ReMNAU,
    AcReMNAU = AcReMNAU,
    MeanAbundance = ma,
    MeanPartAbundance = mpa,
    bone_level = bone_level
  ))
}
