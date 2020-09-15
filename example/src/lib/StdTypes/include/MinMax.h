/*
 * MinMax.h
 *
 *  Created on: May 9, 2015
 *      Author: stepan
 */

#pragma once

namespace bige {
    namespace math {
        template<typename T, typename S>
        T min(T l, S r) { return l < r ? l : r; }
    }
}
