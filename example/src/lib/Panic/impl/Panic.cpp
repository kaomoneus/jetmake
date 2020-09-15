/*
 * Panic.cpp
 *
 *  Created on: Oct 28, 2014
 *      Author: stepan
 */

#include <cstdlib>
#include <cassert>
#include "Panic.h"

namespace bige {
namespace panic {

	static void defaultPanic(const stdtypes::Char *msg) {
		assert(!msg);
	}

    void Do(const stdtypes::Char *msg) {
        (*accessPanicFn())(msg);
    }

#ifdef DEBUG
    void Assert(bool statement, const stdtypes::Char *msg) {
        if (!statement) Do(msg);
    }
#endif

	panicFnTy& accessPanicFn() {
	    static panicFnTy panicFn = defaultPanic;
	    return panicFn;
	}
}
}


