/*
 * Panic.h
 *
 *  Created on: Oct 28, 2014
 *      Author: stepan
 */

#ifndef PANIC_H_
#define PANIC_H_

#include "StdTypes.h"

namespace bige {
namespace panic {

    typedef void (*panicFnTy)(const stdtypes::Char*);

    panicFnTy& accessPanicFn();

    void Do(const stdtypes::Char *msg);

#ifdef DEBUG
	void Assert(bool statement, const stdtypes::Char *msg);
#else
	inline void Assert(bool statement, const stdtypes::Char *msg) {}
#endif

}
}



#endif /* PANIC_H_ */
