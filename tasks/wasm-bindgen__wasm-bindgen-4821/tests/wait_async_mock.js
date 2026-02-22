// Minimal mock for Atomics.waitAsync testing
// This mock is used to test the wake race condition in the multithread executor

let originalWaitAsync = null;

export function installNotifyOnlyWaitAsyncMock() {
    if (typeof Atomics !== 'undefined' && typeof Atomics.waitAsync !== 'undefined') {
        originalWaitAsync = Atomics.waitAsync;
        // Replace waitAsync with a version that always returns a promise that resolves immediately
        Atomics.waitAsync = function(typedArray, index, value, timeout) {
            // Return a promise that resolves immediately to trigger the race condition
            return { async: true, value: Promise.resolve('ok') };
        };
    }
    return originalWaitAsync;
}

export function restoreWaitAsyncMock(original) {
    if (original && typeof Atomics !== 'undefined') {
        Atomics.waitAsync = original;
    }
}
