export function isRequiredTextValid(value) {
  return typeof value === 'string' && value.trim().length > 0
}

export function getRequiredTextError(label, value) {
  return isRequiredTextValid(value) ? '' : `${label} is required.`
}
